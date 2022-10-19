/**
 * @id py/examples/call
 * @name Calls to function
 * @description Finds calls to any function named "len"
 * @tags call
 *       function
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs

predicate isRootFile(File f) {
    f.getAbsolutePath().indexOf("/root/chaos-mesh/build/") = 0
}

class ToOsGetEnv extends DataFlow::Configuration {
    ToOsGetEnv() { this = "ToOsGetEnv" }
    
    override predicate isSource(DataFlow::Node source) {
        isRootFile(source.getLocation().getFile()) and
        source = API::moduleImport("os").getMember("getenv").getACall()
    }
    
    override predicate isSink(DataFlow::Node sink) {
        isRootFile(sink.getLocation().getFile())
    }
}

from DataFlow::Node node, DataFlow::Node osGetEnv, ToOsGetEnv config
where config.hasFlow(node, osGetEnv) and node != osGetEnv
select node, osGetEnv