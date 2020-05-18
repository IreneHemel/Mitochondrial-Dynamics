if(!"RCy3" %in% installed.packages()){
  install.packages("BiocManager")
  BiocManager::install("RCy3")
}
if(!"igraph" %in% installed.packages()){
  install.packages("BiocManager")
  BiocManager::install("igraph")
}
if(!"clusterProfiler" %in% installed.packages()){
  install.packages("BiocManager")
  BiocManager::install("clusterProfiler")
}
library(RCy3)
library(igraph)
library(clusterProfiler)

cytoscapePing()

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

genes <- "FIS1, STOML2, FAM73B, FAM73A, MTFP1, MIEF2, PLD6, MIEF1, MFF, GDAP1, DNM2, OPA1, MSTO1, MFN1, MFN2, MTFR1, DNM1L, SLC25A46" 
cutoffs <- c("0.4", "0.5", "0.6", "0.7")
limits <- c("50","100","150","200")

# load visual style from file
vizstyle.file <- file.path(getwd(), "Dynamics.xml")
LoadStyle.cmd = paste('vizmap load file file="',vizstyle.file,'"', sep="")
commandsRun(LoadStyle.cmd)

for(l in limits) {
  for (value in cutoffs) {
    string.cmd = paste('string protein query query=\"',genes,'\" cutoff=\"',value,'\" species="Homo sapiens" limit=\"',l,'\" newNetName=\"STRING',l,'_',value,'\"', sep='')
    commandsRun(string.cmd)
    assign(paste("data_",l,'_',value, sep = ""), getTableColumns('node', c('display name', 'query term','compartment::mitochondrion')))
    
    deleteTableColumn(column = 'stringdb::structures', table='node')
    deleteTableColumn(column = 'stringdb::sequence', table='node')
    deleteTableColumn(column = 'stringdb::enhancedLabel Passthrough', table='node')
    deleteTableColumn(column = 'stringdb::STRING style', table='node')
    
    # apply visual style ()
    setVisualStyle('Dynamics')
    
    #Select input nodes
    #Select input nodes
    clearSelection()
    selectNodes(c('FIS1', 'STOML2', 'FAM73B', 'FAM73A', 'MTFP1', 'MIEF2', 'PLD6', 'MIEF1', 'MFF', 'GDAP1', 'DNM2', 'OPA1', 'MSTO1', 'MFN1', 'MFN2', 'MTFR1', 'DNM1L', 'SLC25A46'), by.col='query term')
    
    Input <- getSelectedNodes()
    setNodeShapeBypass(Input,'diamond')
    
    # heat propagation
    # https://mkutmon.gitlab.io/tutorial-network-algorithms/NetworkPropagation.html
    diffusionBasic()
    clearSelection()
    setNodeColorMapping("diffusion_output_heat", c(0,0.5), c('#FFFFFF', '#FF0000'), style.name = "Dynamics")
  }
}

