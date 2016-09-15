/*
 * Copyright (C) 2006 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import UIKit

func ==(lhs: DependencyGraph.Node, rhs: DependencyGraph.Node) -> Bool {
    return lhs === rhs
}

/**
 * - Author: Mariotaku Lee
 * - Date: Sep 2, 2016
 */
internal class DependencyGraph {
    /**
     * List of all views in the graph.
     */
    internal var nodes = [Node]()
    
    /**
     * List of nodes in the graph. Each node is identified by its
     * view id (see View#getId()).
     */
    internal var keyNodes = [Int: Node]()
    
    /**
     * Temporary data structure used to build the list of roots
     * for this graph.
     */
    internal var roots = [Node]()
    
    /**
     * Clears the graph.
     */
    internal func clear() {
        for node in self.nodes {
            node.release()
        }
        self.nodes.removeAll()
        
        keyNodes.removeAll()
        roots.removeAll()
    }
    
    /**
     * Adds a view to the graph.
     
     * @param view The view to be added as a node to the graph.
     */
    internal func add(_ view: UIView) {
        let node = Node.acquire(view)
        
        if (view.tag != 0) {
            keyNodes[view.tag] = node
        }
        
        self.nodes.append(node)
    }
    
    /**
     * Builds a sorted list of views. The sorting order depends on the dependencies
     * between the view. For instance, if view C needs view A to be processed first
     * and view A needs view B to be processed first, the dependency graph
     * is: B -> A -> C. The sorted array will contain views B, A and C in this order.
     
     * @param sorted The sorted list of views. The length of this array must
     * *               be equal to getChildCount().
     * *
     * @param rules  The list of rules to take into account.
     */
    internal func getSortedViews(_ sorted: inout [UIView?], rules: [Int]) {
        var roots: [Node] = findRoots(rules)
        var index: Int = 0
        
        var node: Node? = roots.popLast()
        while (node != nil) {
            let view: UIView = node!.view
            let tag: Int = view.tag
            
            sorted[index] = view
            index += 1
            
            for (dependent, _) in node!.dependents {
                dependent.dependencies.removeValue(forKey: tag)
                if (dependent.dependencies.isEmpty) {
                    roots.append(dependent)
                }
            }
            node = roots.popLast()
        }
        
        if (index < sorted.count) {
            fatalError("Circular dependencies cannot exist in RelativeLayout")
        }
    }
    
    /**
     * Finds the roots of the graph. A root is a node with no dependency and
     * with [0..n] dependents.
     
     * @param rulesFilter The list of rules to consider when building the
     * *                    dependencies
     * *
     * @return A list of node, each being a root of the graph
     */
    fileprivate func findRoots(_ rulesFilter: [Int]) -> [Node] {
        // Find roots can be invoked several times, so make sure to clear
        // all dependents and dependencies before running the algorithm
        for node in self.nodes {
            node.dependents.removeAll()
            node.dependencies.removeAll()
        }
        
        // Builds up the dependents and dependencies for each node of the graph
        for node in self.nodes {
            
            let layoutParams = node.view.layoutParams
            let rules = layoutParams.getRules()
            
            // Look only the the rules passed in parameter, this way we build only the
            // dependencies for a specific set of rules
            for filter in rulesFilter {
                let rule = rules[filter]
                if (rule > 0) {
                    // The node this node depends on
                    let dependency = self.keyNodes[rule]
                    // Skip unknowns and self dependencies
                    if (dependency == nil || dependency === node) {
                        continue
                    }
                    // Add the current node as a dependent
                    dependency!.dependents[node] = self
                    // Add a dependency to the current node
                    node.dependencies[rule] = dependency
                }
            }
        }
        
        self.roots.removeAll()
        
        // Finds all the roots in the graph: all nodes with no dependencies
        for node in self.nodes {
            if (node.dependencies.count == 0) {
                roots.append(node)
            }
        }
        
        return roots
    }
    
    /**
     * A node in the dependency graph. A node is a view, its list of dependencies
     * and its list of dependents.
     *
     *
     * A node with no dependent is considered a root of the graph.
     */
    internal class Node: Hashable {
        
        /**
         * The view representing this node in the layout.
         */
        var view: UIView! {
            didSet {
                self.viewStringTag = view?.stringTag
            }
        }
        var viewStringTag: String? = nil
        
        /**
         * The list of dependents for this node; a dependent is a node
         * that needs this node to be processed first.
         */
        var dependents = [Node: DependencyGraph]()
        
        /**
         * The list of dependencies for this node.
         */
        var dependencies = [Int: Node]()
        
        var hashValue: Int {
            return unsafeBitCast(self, to: Int.self)
        }
        
        // START POOL IMPLEMENTATION
        
        // The pool is static, so all nodes instances are shared across
        // activities, that's why we give it a rather high limit
        fileprivate static let POOL_LIMIT = 100
        fileprivate static let sPool = SynchronizedPool<Node>(size: POOL_LIMIT)
        
        static func acquire(_ view: UIView) -> Node {
            let node = sPool.acquire() ?? Node()
            node.view = view
            return node
        }
        
        func release() {
            view = nil
            dependents.removeAll()
            dependencies.removeAll()
            
            Node.sPool.release(self)
        }
        
        // END POOL IMPLEMENTATION
    }
    
}
