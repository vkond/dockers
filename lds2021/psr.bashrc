
#
# PULSAR ENV VARIABLES
#
export OSTYPE=linux
export PSRHOME="/usr/local"

export QTDIR="${PSRHOME}/src/qt3/qt"
export MANPATH="${QTDIR}/doc/man:${MANPATH}"
export LD_LIBRARY_PATH="${QTDIR}/lib:${PSRHOME}/qt3/lib:${LD_LIBRARY_PATH}"
export PATH="${QTDIR}/bin:${PSRHOME}/bin:${PATH}"

#
# Pgplot
# 
export PGPLOT_DIR="${PSRHOME}/lib"
export PGPLOT_FONT="${PGPLOT_DIR}/grfont.dat"
#export PGPLOT_BACKGROUND="white"
export PGPLOT_DEV="/xwindow"
export PGPLOT_TYPE="cps"

export PSRCAT_FILE="${PSRHOME}/bin/psrcat.db"
export TEMPO="${PSRHOME}/src/tempo"
export TEMPO2="${PSRHOME}/share/tempo2/"
export PSRCHIVE="${PSRHOME}/src/psrchive"
export DSPSR="${PSRHOME}/src/dspsr"
export COASTGUARD_CFG="${PSRHOME}/src/coast_guard/configurations"
export SIGPROC="${PSRHOME}/src/sigproc-4.3"
export PRESTO="${PSRHOME}/src/presto"
export PSRCHIVE_CONFIG="${PSRHOME}/etc/psrchive.cfg"
export LOFAR_BF_PULSAR_SCRIPTS="${PSRHOME}/src/LOFAR-BF-pulsar-scripts"
export MSCORPOL="${PSRHOME}/src/mscorpol"
export PULP="${PSRHOME}/src/pulp"

#
# update PATH, LD_LIBRARY_PATH and PYTHONPATH
#
export PATH=".:${HOME}:${HOME}/bin:${PSRHOME}/bin:${SIGPROC}:${PRESTO}/bin:${TEMPO}/src:${TEMPO2}/bin:${PSRCHIVE}/bin:${PSRHOME}/src/coast_guard:${PSRHOME}/bin/lofar_antenna_state:${LOFAR_BF_PULSAR_SCRIPTS}:${LOFAR_BF_PULSAR_SCRIPTS}/simple-sh-scripts:${LOFAR_BF_PULSAR_SCRIPTS}/scheduling:${LOFAR_BF_PULSAR_SCRIPTS}/fluxcal:${LOFAR_BF_PULSAR_SCRIPTS}/LTA:${LOFAR_BF_PULSAR_SCRIPTS}/FE-map:${MSCORPOL}/mscorpol:${MSCORPOL}/lofar_element_response:${PULP}:${PSRHOME}/src/RMCalc:${PATH}"
export LD_LIBRARY_PATH="${PGPLOT_DIR}:${PSRHOME}/lib:/usr/lib/x86_64-linux-gnu:${PSRHOME}/lib64:${PSRCHIVE}/lib:${PRESTO}/lib:${PRESTO}/lib/python:${SIGPROC}:${TEMPO2}/lib:${PSRHOME}/lib/instantclient_11_2:${PSRHOME}/src/dedisp/lib:${PSRHOME}/src/dedisp-multi/lib:${PSRHOME}/lib64/python2.7/site-packages/:${PSRHOME}/lib/python2.7/site-packages:/opt/lofarsoft/lib"
export PYTHONPATH="./:${PSRHOME}/bin:${PSRHOME}/src:${PRESTO}/python:${PSRHOME}/lib/python2.7/site-packages/:${PSRHOME}/lib64/python2.7/site-packages/:${PSRHOME}/lib/python2.7/dist-packages/:${PSRHOME}/src/coast_guard:${PSRHOME}/bin/lofar_antenna_state:${LOFAR_BF_PULSAR_SCRIPTS}/fluxcal:${MSCORPOL}/mscorpol:${PULP}:/opt/lofarsoft/lib/python2.7/site-packages:${PSRHOME}/src/RMCalc"
