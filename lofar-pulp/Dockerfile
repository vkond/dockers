#
# base
#
#FROM ubuntu:12.04
#FROM ubuntu:14.04
FROM ubuntu:16.04

#
# common-environment
#
#ENV USER=lofar
#ENV USER=kondratiev
ENV USER=lofarsys
ENV HOME="/home/${USER}"
ENV INSTALLDIR=/usr/local
#
# set-uid
#
#ENV UID=1000
#ENV UID=7406
ENV UID=7149

#
#
# environment
#
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHON_VERSION=2.7

#
# versions
#
ENV CASACORE_VERSION=latest \
    CASAREST_VERSION=latest

#    PYTHON_CASACORE_VERSION=2.1.2 \
#    BOOST_VERSION=1.58

#
# set-build-options
#
ENV J=6

#
# Base and runtime dependencies
#
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apt-utils
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y sudo

#
# setup-account
#
RUN (getent group sudo &>/dev/null || groupadd sudo) && \
    echo "useradd -m ${USERADD_FLAGS} ${USER}" && \
    useradd -m -u ${UID} ${USER} && \
    usermod -a -G sudo ${USER} && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    sed -i 's/requiretty/!requiretty/g' /etc/sudoers

USER ${USER}


#
# *******************
# Extra packages
# *******************
#
RUN sudo apt-get update && sudo apt-get upgrade -y && \
    sudo apt-get install -y g++ gfortran flex swig bison subversion cmake \
                     zlib1g-dev libatlas-base-dev liblapack-dev \
                     libncurses5-dev libfreetype6-dev libpng12-dev \
                     python-dev python-tk python-pyfits tk8.5-dev fftw3-dev \
                     libbz2-dev git git git-core git-doc git-man git-svn valgrind \
                     wget vim libgtk2.0-dev aptitude tcsh apt-utils locate doxygen \
                     libx11-dev libxt-dev libxmu-dev dh-autoreconf python-mpltoolkits.basemap \
		     imagemagick python-pip dos2unix texlive-font-utils cvs mpich libmpich-dev libmpich12 \
                     python-ephem python3-ephem python-h5py python3-h5py libaio-dev latex2html gv

# also try python-seaborn for later ubuntu

RUN pip install pyephem

#
# *******************
#   Casacore
# *******************
#
RUN sudo apt-get update && sudo apt-get install -y libblas-dev liblapack-dev libfftw3-dev libhdf5-dev libboost-python-dev libcfitsio3-dev wcslib-dev \
    cmake-doc cmake-curses-gui make libgsl0-dev python-matplotlib python-sphinx python-numpy num-utils python-scipy python-sip-dev openmpi-bin openmpi-common ipython && \
    sudo mkdir -p ${INSTALLDIR}/src/casacore/build && \
    sudo mkdir -p ${INSTALLDIR}/src/casacore/data && \
    cd ${INSTALLDIR}/src/casacore && sudo git clone https://github.com/casacore/casacore.git src && \
    if [ "${CASACORE_VERSION}" != "latest" ]; then cd ${INSTALLDIR}/src/casacore/src && sudo git checkout tags/v${CASACORE_VERSION}; fi && \
    cd ${INSTALLDIR}/src/casacore/data && sudo wget --retry-connrefused ftp://ftp.astron.nl/outgoing/Measures/WSRT_Measures.ztar && \
    cd ${INSTALLDIR}/src/casacore/data && sudo tar xf WSRT_Measures.ztar  && sudo rm -f WSRT_Measures.ztar && \
    cd ${INSTALLDIR}/src/casacore/build && sudo cmake -DCMAKE_INSTALL_PREFIX=${INSTALLDIR} -DDATA_DIR=${INSTALLDIR}/src/casacore/data -DBUILD_PYTHON=True -DUSE_OPENMP=True -DUSE_FFTW3=TRUE -DUSE_HDF5=ON ../src/ && \
    cd ${INSTALLDIR}/src/casacore/build && sudo make -j ${J} && \
    cd ${INSTALLDIR}/src/casacore/build && sudo make install && \
    sudo bash -c "strip ${INSTALLDIR}/{lib,bin}/* || true" && \
    sudo bash -c "rm -rf ${INSTALLDIR}/src/casacore/{build,src}" && \
    sudo apt-get purge -y libblas-dev liblapack-dev libfftw3-dev && \
    sudo apt-get autoremove -y

# *******************
#   python-casacore (pyrap)
# *******************
#
# sudo add-apt-repository ppa:radio-astro/main
# sudo apt-get install -y libcasacore21-dev
RUN sudo apt-get install -y software-properties-common && sudo add-apt-repository -s ppa:kernsuite/kern-2 && sudo apt-add-repository multiverse && \
    sudo apt-get update && sudo apt-get install -y python-setuptools && \
    cd ${INSTALLDIR}/src && sudo git clone https://github.com/casacore/python-casacore && \
    cd python-casacore && sudo python ./setup.py install

#
# *******************
#   FFTW
# *******************
#
ARG FFTW_VERSION="3.3.6-pl2"

RUN cd ${INSTALLDIR}/src && sudo wget --retry-connrefused http://www.fftw.org/fftw-${FFTW_VERSION}.tar.gz && \
    sudo tar xvfz fftw-${FFTW_VERSION}.tar.gz && cd fftw-${FFTW_VERSION} && \
    sudo ./configure --prefix=${INSTALLDIR} --enable-shared --enable-threads --enable-single  --enable-sse --enable-sse2 --enable-avx --enable-avx2 && \
    sudo make && sudo make install && sudo make distclean && \
    sudo ./configure --prefix=${INSTALLDIR} --enable-shared --enable-threads --enable-sse2 --enable-avx --enable-avx2 && \
    sudo make && sudo make install && sudo make distclean && \
    sudo ./configure --prefix=${INSTALLDIR} --enable-shared --enable-threads --enable-long-double && \
    sudo make && sudo make install && sudo make distclean && \
    sudo ./configure --prefix=${INSTALLDIR} --enable-shared --enable-threads --enable-quad-precision && \
    sudo make && sudo make install && sudo make distclean

#
# *******************
#   QT3
# *******************
#
ENV QTDIR="${INSTALLDIR}/src/qt3/qt"
ENV PATH="${QTDIR}/bin:${PATH}"
ENV MANPATH="${QTDIR}/doc/man:${MANPATH}"
ENV LD_LIBRARY_PATH="${QTDIR}/lib"

RUN cd ${INSTALLDIR}/src && sudo mkdir -m 755 -p qt3 && cd qt3 && sudo wget --retry-connrefused -t 0 http://download.qt.io/archive/qt/3/qt-x11-free-3.3.8b.tar.gz && \
    sudo tar xvfz qt-x11-free-3.3.8b.tar.gz && sudo mv qt-x11-free-3.3.8b qt && cd qt && \
    sudo sed -i '2i/usr/local/src/qt3/qt/lib' /etc/ld.so.conf && sudo /sbin/ldconfig && \
    sudo sed -i '2358i\ \ \ \ \ \ \ \ break' configure && \
    sudo sed -i '48i#include\ <stddef.h>' src/tools/qvaluelist.h && \
    sudo sed -i '50i#include\ <stddef.h>' src/tools/qmap.h && \
    sudo ./configure --prefix=${INSTALLDIR}/qt3 -qt-gif -thread -stl && \
    sudo sed -i '48i#include\ <stddef.h>' include/qvaluelist.h && \
    sudo sed -i '50i#include\ <stddef.h>' include/qmap.h && \
    sudo make sub-src && sudo cp -l lib/libqt* ${INSTALLDIR}/lib && sudo /sbin/ldconfig && \
    sudo make && sudo make install

ENV LD_LIBRARY_PATH="${INSTALLDIR}/qt3/lib:${LD_LIBRARY_PATH}"
ENV PATH="${INSTALLDIR}/bin:${PATH}"

#
# *******************
#   PGPLOT
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo wget --retry-connrefused ftp://ftp.astro.caltech.edu/pub/pgplot/pgplot522.tar.gz && \
    sudo tar xvfz pgplot522.tar.gz && cd pgplot && \
    sudo sed -i 's/! CGDRIV/CGDRIV/' drivers.list && \
    sudo sed -i 's/! LXDRIV/LXDRIV/' drivers.list && \
    sudo sed -i 's/! PNDRIV/PNDRIV/' drivers.list && \
    sudo sed -i 's/! PSDRIV/PSDRIV/' drivers.list && \
    sudo sed -i 's/! TTDRIV 5/TTDRIV 5/' drivers.list && \
    sudo sed -i 's/! XWDRIV/XWDRIV/1' drivers.list && \
    sudo sed -i 's/Tk_Get3DBorder\ failed:\ \%s\\n\",\ tkpg->interp->result);/Tk_Get3DBorder\ failed\\n\");/' drivers/xtk/tkpgplot.c && \
    sudo ./makemake . linux g77_gcc && \
    sudo sed -i 's=pndriv.o : ./png.h ./pngconf.h ./zlib.h ./zconf.h=#pndriv.o : ./png.h ./pngconf.h ./zlib.h ./zconf.h=' makefile && \
    sudo sed -i '905i\\trm -f cpg*.o' makefile && \
    sudo sed -i '910i\\tgcc -shared -o libcpgplot.so `ls cpg*.o | sort | uniq` $(SHARED_LIB_LIBS) -lpgplot -L./ -L/usr/lib' makefile && \
    sudo make FCOMPL=gfortran SHARED_LIB_LIBS="-lpng -lz -lX11 -lgfortran" all cpg && \
    sudo install -D -m644 libpgplot.a ${INSTALLDIR}/lib/libpgplot.a && \
    sudo install -D -m755 libpgplot.so ${INSTALLDIR}/lib/libpgplot.so && \
    sudo install -D -m644 grfont.dat  ${INSTALLDIR}/lib/grfont.dat && \
    sudo install -D -m644 rgb.txt ${INSTALLDIR}/lib/rgb.txt && \
    sudo install -D -m755 pgxwin_server ${INSTALLDIR}/bin/pgxwin_server && \
    sudo install -D -m644 libcpgplot.a ${INSTALLDIR}/lib/libcpgplot.a && \
    sudo install -D -m644 libcpgplot.so ${INSTALLDIR}/lib/libcpgplot.so && \
    sudo install -D -m644 cpgplot.h ${INSTALLDIR}/include/cpgplot.h

# Setting PGPLOT env variables
ENV PGPLOT_DIR="${INSTALLDIR}/lib"
ENV PGPLOT_DEV="/xwindow"
ENV PGPLOT_TYPE="cps"
ENV PGPLOT_FONT="${PGPLOT_DIR}/grfont.dat"
ENV LD_LIBRARY_PATH="${INSTALLDIR}/lib:/usr/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH}"

#
# *******************
#   PGPLOT Python bindings
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone https://github.com/npat-efault/ppgplot && cd ppgplot && \
    sudo python setup.py install --prefix=${INSTALLDIR}
ENV PYTHONPATH="${INSTALLDIR}/bin:${INSTALLDIR}/lib/python2.7/site-packages/:${INSTALLDIR}/lib/python2.7/dist-packages/"

#
# *******************
#   TEMPO
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone git://git.code.sf.net/p/tempo/tempo && cd tempo && sudo chmod go+w obsys.dat && \
    sudo chmod go-w obsys.dat && sudo ./prepare && sudo ./configure --prefix=${INSTALLDIR} && sudo make && sudo make install

ENV TEMPO="${INSTALLDIR}/src/tempo"

#
# *******************
#   TEMPO2
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone https://bitbucket.org/psrsoft/tempo2.git && cd tempo2 && sudo ./bootstrap && \
    sudo cp -r T2runtime ${INSTALLDIR}/share/tempo2/
ENV TEMPO2="${INSTALLDIR}/share/tempo2/"
RUN cd ${INSTALLDIR}/src/tempo2 && sudo TEMPO2=${TEMPO2} ./configure --prefix=/usr/local && sudo make && sudo make install && \
    sudo make plugins && sudo make plugins-install
    
#
# *******************
#   PSRCAT
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo wget --retry-connrefused http://www.atnf.csiro.au/people/pulsar/psrcat/downloads/psrcat_pkg.tar.gz && \
    sudo tar xvfz psrcat_pkg.tar.gz && cd psrcat_tar && sudo ./makeit && cd ${INSTALLDIR}/lib && \
    sudo ln -sf ${INSTALLDIR}/src/psrcat_tar/libpsrcat.a . && cd ${INSTALLDIR}/bin && \
    sudo ln -sf ${INSTALLDIR}/src/psrcat_tar/psrcat . && sudo ln -sf ${INSTALLDIR}/src/psrcat_tar/psrcat.db . && \
    sudo ln -sf ${INSTALLDIR}/src/psrcat_tar/glitch.db .
ENV PSRCAT_FILE="${INSTALLDIR}/bin/psrcat.db"

#
# *******************
#   SIGPROC
# *******************
#
ENV OSTYPE=linux
ARG customcfg="makefile.${OSTYPE}"
RUN cd ${INSTALLDIR}/src && \
    sudo wget -O sigproc-4.3.tar.gz --retry-connrefused "http://downloads.sourceforge.net/project/sigproc/sigproc/4.3/sigproc-4.3.tar.gz?r=http%3A%2F%2Fsigproc.sourceforge.net%2F&amp;ts=1483801820&amp;use_mirror=freefr" && \
    sudo tar xvfz sigproc-4.3.tar.gz && sudo chown -R root:root sigproc-4.3 && sudo chmod -R og+w sigproc-4.3 && cd sigproc-4.3 && \
    sudo sed -i 's/$<//' configure && sudo ./configure && \
    sudo sed -i 's/-L\/usr\/X11R6\/lib/-L\/usr\/lib\/x86_64-linux-gnu\//' ${customcfg} && \
    sudo sed -i '9iLFITS = -L/usr/lib -lcfitsio' ${customcfg} && \
    sudo sed -i '10iLFFTW = -L/usr/local/lib/ -lfftw3 -lfftw3f' ${customcfg} && \
    sudo sed -i '11iFC = gfortran -ffixed-line-length-none' ${customcfg} && \
    sudo sed -i "265s/DB\\\\'s/DBs/" dosearch.f && \
    sudo sed -i '452s/export\ :/export:/' makefile && \
    sudo sed -i 's/$(OSTYPE)/linux/' makefile && \
    sudo sed -i 's/ar\ rv/ar\ rvU/' makefile && \
    sudo sed -i 's/$(LPGPLOT)/-L\/usr\/local\/lib\ -lpgplot\ -lcpgplot\ -L\/usr\/lib\/x86_64-linux-gnu\/\ -lX11/' makefile && \
    sudo sed -i 's/$(LFITS)/-L\/usr\/lib\ -lcfitsio/' makefile && \
    sudo sed -i 's/$(LFFTW)/-L\/usr\/local\/lib\/\ -lfftw3\ -lfftw3f/' makefile && \
    sudo make && sudo make quickplot && sudo make extract && sudo make gmrt2fil && \
    sudo make flatten && sudo make clip && sudo make downsample && sudo make readchunk && \
    sudo make splitter && sudo make snrdm && sudo make dice && sudo make depolyco && \
    sudo make brute && sudo make tree && sudo make pgplotter && sudo make sumfft && \
    sudo make peak && sudo make ffa && sudo make spec && sudo make makedummy && \
    sudo cp libsigproc_linux.a ${INSTALLDIR}/lib
ENV SIGPROC="${INSTALLDIR}/src/sigproc-4.3"

#
# ******************* 
#   PRESTO
# *******************
#
ENV PRESTO="${INSTALLDIR}/src/presto"
RUN cd ${INSTALLDIR}/src && sudo git clone git://github.com/scottransom/presto.git && \
    cd presto/src && sudo make PRESTO=${PRESTO} makewisdom 
RUN cd ${PRESTO}/src && sudo make PRESTO=${PRESTO} prep && \
    sudo make PRESTO=${PRESTO} LD_LIBRARY_PATH=${PRESTO}/lib PGPLOT_DIR=${PGPLOT_DIR} && \
    sudo make PRESTO=${PRESTO} mpi && cd ../python && \
    sudo PRESTO=${PRESTO} PGPLOT_DIR=${PGPLOT_DIR} PYTHONPATH="${PRESTO}/lib/python:${PRESTO}/python" LD_LIBRARY_PATH="${INSTALLDIR}/lib:${PRESTO}/lib" make

#
# *******************
#   PSRDADA
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo cvs -z3 -d:pserver:anonymous@psrdada.cvs.sourceforge.net:/cvsroot/psrdada co -P psrdada && \
    cd psrdada && sudo sed -i 's/mopsr\ //' Makefile.am && sudo ./bootstrap && \
    sudo ./configure --prefix=${INSTALLDIR} --enable-shared --with-x && sudo make && sudo make install

#
# *******************
#   PSRCHIVE
# *******************
#
# sed here is necessary because QT3 configure test is not passed (don't know why)
# also psrgui's compilation fails, so I turned it off as well
#
RUN cd ${INSTALLDIR}/src && sudo git clone git://git.code.sf.net/p/psrchive/code psrchive && cd psrchive && \
    sudo sed -i '338i\ \ \ \ \ \ have_qt="yes"' config/bnv_have_qt.m4 && \
    sudo sed -i 's/SUBDIRS\ +=\ psrgui/#SUBDIRS\ +=\ psrgui/' More/Makefile.am && sudo ./bootstrap && \
    sudo ./configure --prefix=/usr/local --enable-shared --with-x --with-psrcat=psrcat --with-Qt-include-dir=/usr/local/qt3/include \
       --with-Qt-bin-dir=/usr/local/qt3/bin --with-Qt-lib-dir=/usr/local/qt3/lib --with-Qt-lib=qt-mt && \
    sudo make && sudo make install
ENV PSRCHIVE="${INSTALLDIR}"
ENV PSRCHIVE_CONFIG="${INSTALLDIR}/etc/psrchive.cfg"

#
# *******************
#   mark5access library
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone https://github.com/demorest/mark5access && cd mark5access && \
    sudo aclocal && sudo libtoolize --copy --force && sudo autoconf && sudo autoheader && sudo automake -a -c && \
    sudo ./configure --prefix=${INSTALLDIR} && sudo make && sudo make install

#
# *******************
#   DAL
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone https://github.com/nextgen-astrodata/DAL.git DAL && \
    cd DAL && sudo mkdir build && cd build && sudo cmake -DCMAKE_INSTALL_PREFIX=${INSTALLDIR} .. && \
    sudo make && sudo make install

#
# *******************
#   DSPSR
# *******************
#
# backends removed: fadc puma
#
RUN cd ${INSTALLDIR}/src && sudo git clone git://git.code.sf.net/p/dspsr/code dspsr && sudo chmod go+w dspsr && cd dspsr && \
    sudo ./bootstrap && sudo sed -i 's/AR_FLAGS=cru/AR_FLAGS=cruU/' config/libtool.m4 && \
    sudo sed -i 's/-lhdf5/-lhdf5_serial/' Kernel/Formats/lofar_dal/Makefile.am && \
    sudo echo "apsr asp bcpm bpsr caspsr cpsr cpsr2 dada dummy fits gmrt guppi kat lbadr lbadr64 lofar_dal lump lwa mark4 mark5 mark5b maxim mwa pdev pmdaq puma2 s2 sigproc ska1 spda1k spigot vdif wapp" > backends.list && \
    sudo CPPFLAGS=-I/usr/include/hdf5/serial LIBS="-lpsrdada -lhdf5_serial -lcpgplot" LDFLAGS="-L/usr/local/lib -L/usr/lib/x86_64-linux-gnu" ./configure --prefix=${INSTALLDIR} --enable-shared --with-x && \
    sudo make && sudo make install
ENV DSPSR="${INSTALLDIR}/src/dspsr"

#
# *******************
#   COAST_GUARD
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone https://github.com/plazar/coast_guard
ENV COASTGUARD_CFG="${INSTALLDIR}/src/coast_guard/configurations"

#
# *******************
#   PSRFITS_UTILS
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone https://github.com/demorest/psrfits_utils && \
    cd psrfits_utils && sudo sed -i 's/-Werror\ //' configure.ac && \
    sudo ./prepare && sudo ./configure --prefix=${INSTALLDIR} && sudo make && sudo make install

#
# *******************
#   SEE
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone https://github.com/vkond/see && cd see && sudo make && \
    sudo cp see ${INSTALLDIR}/bin

#
# *******************
#   mscorpol
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone https://github.com/2baOrNot2ba/mscorpol && cd ${INSTALLDIR}/src && \
    sudo chown -R root:root mscorpol && sudo chmod -R g+w mscorpol && \
    cd mscorpol/lofar_element_response && sudo make && \
    cd ../mscorpol && sudo sed -i '1s/AntennaFieldDirectory/#AntennaFieldDirectory/' parseAntennaField.py && \
    antenna_field_dir="${INSTALLDIR}/etc/StaticMetaData/AntennaFields/" && \
    sudo sed -i "2iAntennaFieldDirectory=\"$antenna_field_dir\"" parseAntennaField.py
ENV MSCORPOL="${INSTALLDIR}/src/mscorpol"

# dummy variable to indicate from which line to rebuild the image
ENV START_REBUILD_FROM_HERE="19092017"

#
# *******************
#   lofar_lta
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo wget http://www.astro-wise.org/losoft/lofar_lta-2.6.0.tar.gz && \
    sudo tar xvfz lofar_lta-2.6.0.tar.gz && cd lofar_lta-2.6.0 && \
    sudo python setup.py install_oracle --prefix=${INSTALLDIR} && \
    sudo python setup.py install --prefix=${INSTALLDIR}

#
# *******************
#   LOFAR-BF-pulsar-scripts
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone https://github.com/vkond/LOFAR-BF-pulsar-scripts && \
    cd LOFAR-BF-pulsar-scripts && \
    sudo cp subdyn.py ${INSTALLDIR}/bin && \
    cd FE-map && \
    sudo sed -i '27s/stations_file/#stations_file/' lofar_status_map.py && \
    statdir=`pwd` && sudo sed -i "28istations_file=\"$statdir/stations.txt\"" lofar_status_map.py && \
    cd ../fluxcal && flaggeddir=`pwd` && sudo sed -i "s|\/home\/astron\/kondratiev\/pulsar\/etc\/flagged-antennas-tom-hassall|$flaggeddir|g" lofar_fluxcal.py && \
    sudo sed -i "s|\/home\/astron\/kondratiev\/pulsar\/etc\/flagged-antennas-tom-hassall|$flaggeddir|g" lofar_psrflux.py && \
    sudo sed -i "s|\/home\/astron\/kondratiev\/pulsar\/etc\/flagged-antennas-tom-hassall|$flaggeddir|g" lofar_fluxcal.py.orig && \
    sudo sed -i "s|\/home\/astron\/kondratiev\/pulsar\/etc\/flagged-antennas-tom-hassall|$flaggeddir|g" lofar_psrflux.py.orig && \
    sudo sed -i "71s|%s\/release\/share\/pulsar\/data|$flaggeddir|" lofar_gain.py && \
    cd ../scheduling && scheddir="${INSTALLDIR}/etc/xml-templates" && sudo sed -i "37s|%s\/release\/share\/pulsar\/data\/templates|$scheddir|"  bfscheduler.py && \
    cd ../LTA && sudo cp Environment.cfg ${HOME}/.awe/

#
# *******************
#   PULP
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone https://github.com/vkond/pulp
ENV PULP="${INSTALLDIR}/src/pulp"

#
# I need this repository to copy some necessary scripts, Pulp, 2bf2fits, etc
#
#ARG LOFARSOFT="${INSTALLDIR}/src/lofarsoft"
ENV LOFARSOFT="/opt/lofarsoft"
RUN sudo mkdir -p ${LOFARSOFT} && cd ${LOFARSOFT} && sudo svn co http://usg.lofar.org/svn/code/trunk .
# installing 2bf2fits & bf2puma2 (just in case)
RUN cd ${LOFARSOFT}/src/Pulsar/apps && sudo rsync -avxP bf2format ${INSTALLDIR}/src/ && \
    cd ${INSTALLDIR}/src/bf2format && \
    sudo gcc  -DDEBUGGING_MESSAGES -DHAVE_CFITSIO -DHAVE_GLIB -DHAVE_PGPLOT -DHAVE_MPI -DHAVE_FFTW3 -O2 -I${INSTALLDIR}/include -o 2bf2fits.o -c 2bf2fits.c && \
    sudo gcc  -O2 2bf2fits.o  -o 2bf2fits -rdynamic -lm -lcfitsio && \
    sudo cp 2bf2fits ${INSTALLDIR}/bin && \
    sudo g++ bf2puma2.cpp -o bf2puma2 && \
    sudo cp bf2puma2 ${INSTALLDIR}/bin
# copying XML templates to /usr/local/etc/xml-templates, copying psrchive.cfg to /usr/local/etc, 
# making the link to StaticMetaData in USG trunck in our /usr/local/etc
RUN cd ${INSTALLDIR}/etc && sudo mkdir xml-templates && sudo ln -sf ${LOFARSOFT}/data/lofar/StaticMetaData StaticMetaData && \
    sudo cp ${LOFARSOFT}/src/Pulsar/scripts/psrchive.cfg . && \
    sudo sed -i 's/^Predictor::default = polyco/Predictor::default = tempo2/' psrchive.cfg && \
    cd xml-templates && sudo rsync -avxP ${LOFARSOFT}/src/Pulsar/scripts/XML-MOM/ .
# installing modified version of Sigproc's splice (to be called sigproc_splice)
RUN cd ${INSTALLDIR}/src && sudo mkdir sigproc_splice && cd sigproc_splice && sudo cp ${LOFARSOFT}/src/Pulsar/apps/sigproc-4.3/splice.c . && \
    sudo gcc -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -I${INSTALLDIR}/src/sigproc-4.3  splice.c -o sigproc_splice -lm -lsigproc_linux && \
    sudo cp sigproc_splice ${INSTALLDIR}/bin
# copy some of the scripts that are needed for Pulp
RUN cd ${INSTALLDIR}/bin && sudo cp ${LOFARSOFT}/src/Pulsar/scripts/digitize.py . && \
    sudo cp ${LOFARSOFT}/src/Pulsar/scripts/plot_LOFAR_TA_multibeam3.py . && \
    sudo cp ${LOFARSOFT}/src/Pulsar/scripts/RRAT_heatmap2.py . && \
    sudo cp ${LOFARSOFT}/src/Pulsar/scripts/fix_fits_coordinates.py . && \
    sudo cp ${LOFARSOFT}/src/Pulsar/scripts/spectar.py . && \
    sudo cp ${LOFARSOFT}/src/Pulsar/scripts/single_pulse_search_lotaas.py . && \
    cd ../etc && sudo cp ${LOFARSOFT}/src/Pulsar/scripts/header.puma2 . && \
    sudo cp ${LOFARSOFT}/src/Pulsar/scripts/lofar_default.inf . && \
    sudo rm -rf ${LOFARSOFT}/src/Pulsar/apps && sudo rm -rf ${LOFARSOFT}/src/Pulsar/external

ENV PYTHONPATH="./:${PRESTO}/lib/python:${PRESTO}/python:${INSTALLDIR}/bin:${INSTALLDIR}/src:${INSTALLDIR}/lib/python2.7/site-packages/:${INSTALLDIR}/lib/python2.7/dist-packages/:${INSTALLDIR}/src/coast_guard:${INSTALLDIR}/bin/lofar_antenna_state:${INSTALLDIR}/src/LOFAR-BF-pulsar-scripts/fluxcal:${MSCORPOL}/mscorpol:${PULP}"
ENV LD_LIBRARY_PATH="${PGPLOT_DIR}:${PRESTO}/lib:${PRESTO}/lib/python:${INSTALLDIR}/lib:/usr/lib:${SIGPROC}:${TEMPO2}/lib:${INSTALLDIR}/lib64:${INSTALLDIR}/lib/instantclient_11_2:${INSTALLDIR}/src/dedisp-multi/lib:${INSTALLDIR}/src/dedisp/lib"
ENV PATH=".:${HOME}:${HOME}/bin:${INSTALLDIR}/bin:/opt/bin:${PRESTO}/bin:${SIGPROC}:${TEMPO}/src:${PGPLOT_DIR}:${TEMPO2}/bin:${SIGPROC}:${INSTALLDIR}/src/coast_guard:${INSTALLDIR}/bin/lofar_antenna_state:${INSTALLDIR}/src/LOFAR-BF-pulsar-scripts:${INSTALLDIR}/src/LOFAR-BF-pulsar-scripts/simple-sh-scripts:${INSTALLDIR}/src/LOFAR-BF-pulsar-scripts/scheduling:${INSTALLDIR}/src/LOFAR-BF-pulsar-scripts/fluxcal:${INSTALLDIR}/src/LOFAR-BF-pulsar-scripts/LTA:${INSTALLDIR}/src/LOFAR-BF-pulsar-scripts/FE-map:${MSCORPOL}/mscorpol:${MSCORPOL}/lofar_element_response:${PULP}:${PATH}"

RUN sudo updatedb

#
# config
#
COPY bashrc ${HOME}/.bashrc
COPY psr.bashrc ${HOME}/.psr.bashrc
COPY dir_colors ${HOME}/.dir_colors
COPY bashrc psr.bashrc dir_colors ${INSTALLDIR}/etc/

#
# entry
#
COPY chuser.sh /usr/local/bin/chuser.sh
WORKDIR ${HOME}
ENTRYPOINT ["sudo","-E","/usr/local/bin/chuser.sh"]
