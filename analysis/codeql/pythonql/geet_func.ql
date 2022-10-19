/**
 * @id py/examples/call
 * @name func to function
 * @description Finds calls to any function named "len"
 * @tags call
 *       function
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs

predicate isRootFile(File f) {
    f.getAbsolutePath().indexOf("/root/") = 0
}



from DataFlow::Node node
where isRootFile(node.getLocation().getFile())
select node