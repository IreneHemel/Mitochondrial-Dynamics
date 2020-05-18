# Applied with 
# Cytoscape version 3.7.1
# CyTargetLinker version 4.0.1
# stringApp version 1.5.0
# R version 3.6.0
# RCy3 version 2.4.0
if(!"RCy3" %in% installed.packages()){
  install.packages("BiocManager")
  BiocManager::install("RCy3")
}
if(!"igraph" %in% installed.packages()){
  install.packages("BiocManager")
  BiocManager::install("igraph")
}
if(!"rstudioapi" %in% installed.packages()){
  install.packages("BiocManager")
  BiocManager::install("rstudioapi")
}

library(RCy3)
library(igraph)
library(rstudioapi)

cytoscapePing()

#Put script and additional files in the same folder
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Create network
genes <- "FIS1, STOML2, FAM73B, FAM73A, MTFP1, MIEF2, PLD6, MIEF1, MFF, GDAP1, DNM2, OPA1, MSTO1, MFN1, MFN2, MTFR1, DNM1L, SLC25A46" 
value <- "0.5"
l <- "100"

# load visual style from file
vizstyle.file <- file.path(getwd(), "Dynamics_MitoCarta.xml")
LoadStyle.cmd = paste('vizmap load file file="',vizstyle.file,'"', sep="")
commandsRun(LoadStyle.cmd)


string.cmd = paste('string protein query query=\"',genes,'\" cutoff=\"',value,'\" species="Homo sapiens" limit="0" newNetName=\"STRING',l,'_',value,'\"', sep='')
commandsRun(string.cmd)
string2.cmd <- paste('string expand additionalNodes=\"',l,'\" network=\"CURRENT\" nodeTypes=\'Homo sapiens\'')
commandsRun(string2.cmd)

deleteTableColumn(column = 'stringdb::structures', table='node')
deleteTableColumn(column = 'stringdb::sequence', table='node')
deleteTableColumn(column = 'stringdb::enhancedLabel Passthrough', table='node')
deleteTableColumn(column = 'stringdb::STRING style', table='node')

#Might have to rerun the following two lines in case visualisation does not work
MitoCarta <- read.delim('MitoCarta_0.5_100.txt')
loadTableData(MitoCarta, data.key.column = "Protein", table.key.column = "display name")

# apply visual style ()
setVisualStyle('Dynamics_MitoCarta')
renameNetwork('STRING_MitoCarta')

#Select input nodes
clearSelection()
selectNodes(c('FIS1', 'STOML2', 'FAM73B', 'FAM73A', 'MTFP1', 'MIEF2', 'PLD6', 'MIEF1', 'MFF', 'GDAP1', 'DNM2', 'OPA1', 'MSTO1', 'MFN1', 'MFN2', 'MTFR1', 'DNM1L', 'SLC25A46'), by.col='query term')

Input <- getSelectedNodes()
setNodeShapeBypass(Input,'diamond')

# heat propagation
# https://mkutmon.gitlab.io/tutorial-network-algorithms/NetworkPropagation.html
diffusionBasic()
clearSelection()
setNodeColorMapping("diffusion_output_heat", c(0,0.5), c('#FFFFFF', '#FF0000'), style.name = "Dynamics_MitoCarta")
assign(paste("data_",l,'_',value, sep = ""), getTableColumns('node', c('display name', 'diffusion_output_heat', 'diffusion_output_rank')))

#Select one added protein
connections <- c("OPA3", "USP30", "MAB21L3", "PACS2", "SH3TC2", "COX4I1", "TMEM232", "PARK2", "RHOT1", "MB21D2", "TAMM41", "ERICH6B", "PGAM5", "TOMM70A", "TFAM", "KRTAP5-5", "BNIP3", "IMMT", "INF2", "TOMM22", "VDAC1", "TOMM40", "ITPRIPL2", "BIK", "PEX11A", "DNM1", "WBP1L", "YME1L1", "FUNDC1", "PEX11B", "PARL", "PINK1", "DENR", "TOMM20", "MUL1", "OMA1", "S antigen", "MARCH5", "FAM73B", "SLC25A46", "DNM1L", "MTFR1", "MFN2", "FAM73A", "MFN1", "MSTO1", "OPA1", "DNM2", "GDAP1", "MFF", "MIEF1", "PLD6", "MIEF2", "MTFP1", "STOML2", "FIS1", "SPG7", "TMEM39B", "GABARAPL1", "HSPA9", "TMSL8", "SMDT1", "GABARAPL2", "CCDC126", "OR10A3", "EPS15L1", "SLC48A1", "CSRNP2", "TRAK1", "SOD2", "DNASE2", "BPIFA3", "CCDC174", "TOMM7", "FAM45A", "SH3GL1", "PPIF", "PEX3", "AVL9", "EPS15", "STRBP", "MTMR2", "LITAF", "PMP22", "BECN1", "MAP1LC3A", "SLC16A4", "TMEM74", "GJB1", "CYCS", "MAVS", "PEX19", "NOSTRIN", "ATG12", "FAM46D", "TMEM198", "MCU", "NRF1", "BCAP31", "APOOL", "BNIP3L", "ATG5", "DNM3", "VDAC2", "RMDN3", "VDAC3", "MPZ", "PEX11G", "RHOT2", "MTERF3", "AFG3L2", "PHB2", "CHCHD3", "MAP1LC3B", "SBF2", "TMEM126A", "SH3GLB1", "SAMM50")

for (c in connections){
selectNodes(c, by.col='display name')
  selectFirstNeighbors(direction = "any")
  assign(paste("degree_",c, sep = ""), getSelectedNodeCount())
  n <- 0
  count <- getSelectedNodes()
  
  if ("9606.ENSP00000220822" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000373905" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000449089" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000266263" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000302037" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000317177" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000245564" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000348211" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000235329" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000393675" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000348886" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000420617" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000223136" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000262146" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000351138" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000379057" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000327124" %in% count) {
    n <- n+1
  }
  if ("9606.ENSP00000354681" %in% count) {
    n <- n+1
  }

  assign(paste("count_",c, sep = ""), n)
  
  clearSelection()
} 
Degree_0.5_100 <- rbind(degree_OPA3, degree_USP30, degree_MAB21L3, degree_PACS2, degree_SH3TC2, degree_COX4I1, degree_TMEM232, degree_PARK2, degree_RHOT1, degree_MB21D2, degree_TAMM41, degree_ERICH6B, degree_PGAM5, degree_TOMM70A, degree_TFAM, degree_BNIP3, degree_IMMT, degree_INF2, degree_TOMM22, degree_VDAC1, degree_TOMM40, degree_ITPRIPL2, degree_BIK, degree_PEX11A, degree_DNM1, degree_WBP1L, degree_YME1L1, degree_FUNDC1, degree_PEX11B, degree_PARL, degree_PINK1, degree_DENR, degree_TOMM20, degree_MUL1, degree_OMA1, degree_MARCH5, degree_FAM73B, degree_SLC25A46, degree_DNM1L, degree_MTFR1, degree_MFN2, degree_FAM73A, degree_MFN1, degree_MSTO1, degree_OPA1, degree_DNM2, degree_GDAP1, degree_MFF, degree_MIEF1, degree_PLD6, degree_MIEF2, degree_MTFP1, degree_STOML2, degree_FIS1, degree_SPG7, degree_TMEM39B, degree_GABARAPL1, degree_HSPA9, degree_TMSL8, degree_SMDT1, degree_GABARAPL2, degree_CCDC126, degree_OR10A3, degree_EPS15L1, degree_SLC48A1, degree_CSRNP2, degree_TRAK1, degree_SOD2, degree_DNASE2, degree_BPIFA3, degree_CCDC174, degree_TOMM7, degree_FAM45A, degree_SH3GL1, degree_PPIF, degree_PEX3, degree_AVL9, degree_EPS15, degree_STRBP, degree_MTMR2, degree_LITAF, degree_PMP22, degree_BECN1, degree_MAP1LC3A, degree_SLC16A4, degree_TMEM74, degree_GJB1, degree_CYCS, degree_MAVS, degree_PEX19, degree_NOSTRIN, degree_ATG12, degree_FAM46D, degree_TMEM198, degree_MCU, degree_NRF1, degree_BCAP31, degree_APOOL, degree_BNIP3L, degree_ATG5, degree_DNM3, degree_VDAC2, degree_RMDN3, degree_VDAC3, degree_MPZ, degree_PEX11G, degree_RHOT2, degree_MTERF3, degree_AFG3L2, degree_PHB2, degree_CHCHD3, degree_MAP1LC3B, degree_SBF2, degree_TMEM126A, degree_SH3GLB1, degree_SAMM50)
Count_0.5_100 <- rbind(count_OPA3, count_USP30, count_MAB21L3, count_PACS2, count_SH3TC2, count_COX4I1, count_TMEM232, count_PARK2, count_RHOT1, count_MB21D2, count_TAMM41, count_ERICH6B, count_PGAM5, count_TOMM70A, count_TFAM, count_BNIP3, count_IMMT, count_INF2, count_TOMM22, count_VDAC1, count_TOMM40, count_ITPRIPL2, count_BIK, count_PEX11A, count_DNM1, count_WBP1L, count_YME1L1, count_FUNDC1, count_PEX11B, count_PARL, count_PINK1, count_DENR, count_TOMM20, count_MUL1, count_OMA1, count_MARCH5, count_FAM73B, count_SLC25A46, count_DNM1L, count_MTFR1, count_MFN2, count_FAM73A, count_MFN1, count_MSTO1, count_OPA1, count_DNM2, count_GDAP1, count_MFF, count_MIEF1, count_PLD6, count_MIEF2, count_MTFP1, count_STOML2, count_FIS1, count_SPG7, count_TMEM39B, count_GABARAPL1, count_HSPA9, count_TMSL8, count_SMDT1, count_GABARAPL2, count_CCDC126, count_OR10A3, count_EPS15L1, count_SLC48A1, count_CSRNP2, count_TRAK1, count_SOD2, count_DNASE2, count_BPIFA3, count_CCDC174, count_TOMM7, count_FAM45A, count_SH3GL1, count_PPIF, count_PEX3, count_AVL9, count_EPS15, count_STRBP, count_MTMR2, count_LITAF, count_PMP22, count_BECN1, count_MAP1LC3A, count_SLC16A4, count_TMEM74, count_GJB1, count_CYCS, count_MAVS, count_PEX19, count_NOSTRIN, count_ATG12, count_FAM46D, count_TMEM198, count_MCU, count_NRF1, count_BCAP31, count_APOOL, count_BNIP3L, count_ATG5, count_DNM3, count_VDAC2, count_RMDN3, count_VDAC3, count_MPZ, count_PEX11G, count_RHOT2, count_MTERF3, count_AFG3L2, count_PHB2, count_CHCHD3, count_MAP1LC3B, count_SBF2, count_TMEM126A, count_SH3GLB1, count_SAMM50)
write.table(Degree_0.5_100, "Degree_0.t_100.txt", sep = "\t")
write.table(Count_0.5_100, "Count_0.5_100.txt", sep = "\t")

#Transcription factor extention 
Proximal <- file.path(getwd(), "encode-proximal-2012.xgmml")
Distal <- file.path(getwd(), "encode-distal-2012.xgmml")
CTLextend.cmd = paste('cytargetlinker extend idAttribute="display name" linkSetFiles="', Proximal, ',', Distal, '" network=current direction=SOURCES', sep="")
commandsRun(CTLextend.cmd)
layoutNetwork()
renameNetwork('TF_extended')

vizstyle.file <- file.path(getwd(), "CyTargetLinker.xml")
LoadStyle.cmd = paste('vizmap load file file="',vizstyle.file,'"', sep="")
commandsRun(LoadStyle.cmd)
setVisualStyle('CyTargetLinker')

connectionsp <- c("MAX", "REST", "EBF1", "NFYB", "SP2", "EGR1", "PBX3", "PAX5", "IRF3", "NRF1", "SP1", "SRF", "SPI1", "YY1", "MYC", "ELF1", "ELK4", "NFYA", "FOS", "GABPA", "USF1", "GATA1", "EP300", "FOSL1", "FOSL2", "HNF4A", "HNF4G", "JUNB", "JUND", "MAFF", "MAFK")

for (c in connectionsp){
  selectNodes(c, by.col='CTL.name')
  selectFirstNeighbors(direction = "outgoing")
  assign(paste("TF_",c, sep = ""), getSelectedNodes())
  clearSelection()
    
}

TF <- rbind(TF_MAX, TF_REST, TF_EBF1, TF_NFYB, TF_SP2, TF_EGR1, TF_PBX3, TF_PAX5, TF_IRF3, TF_NRF1, TF_SP1, TF_SRF, TF_SPI1, TF_YY1, TF_MYC, TF_ELF1, TF_ELK4, TF_NFYA, TF_FOS, TF_GABPA, TF_USF1, TF_GATA1, TF_EP300, TF_FOSL1, TF_FOSL2, TF_HNF4A, TF_HNF4G, TF_JUNB, TF_JUND, TF_MAFF, TF_MAFK)
write.table(TFP, "TFP_0.5_100.txt", sep="\t")
