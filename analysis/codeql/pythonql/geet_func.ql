/**
 * @id py/examples/example
 * @name Calls to function
 * @description Finds calls to any function named "len"
 * @tags example
 *       function
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs
import semmle.python.Flow

predicate isFile0(File f) {
    f.getAbsolutePath().indexOf("/root/compute-engine/jobs/infra_report/") = 0
}

predicate isFile1(File f) {
    f.getAbsolutePath().indexOf("/root/compute-engine/jobs/infra_report/schema.py") = 0
}


predicate isFile2(File f) {
    f.getAbsolutePath().indexOf("/root/PycharmProjects/testcg/try_pycg.py") = 0
}


class ClassVariableFlow extends DataFlow::Configuration {
    ClassVariableFlow() { this = "ClassVariableFlow"}

    override predicate isSource(DataFlow::Node source) {
        isFile2(source.getLocation().getFile())
    }
    override predicate isSink(DataFlow::Node sink) {   
        isFile2(sink.getLocation().getFile())
    }

    override predicate isAdditionalFlowStep(DataFlow::Node source, DataFlow::Node sink) {
        isFile2(source.getLocation().getFile()) and
        isFile2(sink.getLocation().getFile()) and
        sink instanceof DataFlow::CallCfgNode and
        sink.asCfgNode().(CallNode).getAnArg() = source.asCfgNode()
        
    }
}


from ClassVariableFlow config,DataFlow::Node source,DataFlow::Node sink
where config.hasFlow(source, sink) and source != sink
select sink.getLocation(), source, sink