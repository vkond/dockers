#
# base
#
#FROM ubuntu:12.04
#FROM ubuntu:14.04
FROM ubuntu:16.04
#FROM ubuntu:18.04
#FROM ubuntu:20.04
LABEL Maintainer="kondratiev@astron.nl"

#
# common-environment
#
#ENV USER=lofar
#ENV USER=kondratiev
#ENV USER=lofarsys
#ENV HOME="/home/${USER}"
ENV INSTALLDIR=/usr/local
#
# set-uid
#
#ENV UID=1000
#ENV UID=7406
#ENV UID=7149

#
#
# environment
#
ENV DEBIAN_FRONTEND=noninteractive
#ENV PYTHON_VERSION=2.7
ENV HDF5_USE_FILE_LOCKING=FALSE

#
# versions
#
#ENV CASACORE_VERSION=latest \
#    CASAREST_VERSION=latest

#    PYTHON_CASACORE_VERSION=2.1.2 \
#    BOOST_VERSION=1.58

#
# set-build-options
#
ENV J=6

# install common dependencies
RUN apt-get update && apt-get --yes install --no-install-recommends apt-utils aptitude \
        bison build-essential cmake cvs dh-autoreconf dos2unix doxygen emacs flex g++ gcc gettext-base \
        gfortran git git-core git-doc git-man git-svn gv \
        imagemagick libaio-dev latex2html libarmadillo-dev libatlas-base-dev libblas-dev \
        libboost-date-time-dev libboost-dev libboost-filesystem-dev libboost-program-options-dev \
        libboost-python-dev libboost-regex-dev libboost-signals-dev libboost-system-dev \
        libboost-thread-dev libbz2-dev libcfitsio-dev libfftw3-dev libfreetype6-dev libgsl-dev libgtkmm-3.0-dev \
        libhdf5-serial-dev liblapack-dev liblapacke-dev liblog4cplus-1.1-9 liblog4cplus-dev libmpich-dev \
        libmpich12 libncurses5-dev libpng-dev libpython2.7-dev libreadline-dev libx11-dev libxt-dev \
        libxmu-dev libxml2-dev locate mpich openssh-server python python-dev python-pip python-tk \
        python-pyfits python-setuptools python-mpltoolkits.basemap python-numpy python3-numpy python-scipy python3-scipy \
	python-matplotlib python3-matplotlib python-ephem python3-ephem python-h5py python3-h5py python-seaborn \
        python3-seaborn python-astropy python3-astropy python-virtualenv python3-virtualenv python-tk python3-tk \
        subversion sudo swig tcsh rsync texlive-font-utils tk8.5-dev valgrind vim wcslib-dev wget zlib1g-dev && rm -rf /var/lib/apt/lists/*

# update
RUN sudo pip install setuptools wheel
RUN sudo pip install matplotlib seaborn numpy scipy h5py

# cleaning
RUN sudo apt-get update && sudo apt-get clean && sudo apt-get autoremove --purge

# install python2 packages
#RUN pip install setuptools wheel Cython
#RUN pip install --upgrade aplpy Jinja2 numpy==1.16 PySocks python-monetdb shapely wcsaxes xmlrunner

#
# setup-account
#
#RUN (getent group sudo &>/dev/null || groupadd sudo) && \
#    echo "useradd -m ${USERADD_FLAGS} ${USER}" && \
#    useradd -m -u ${UID} ${USER} && \
#    usermod -a -G sudo ${USER} && \
#    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
#    sed -i 's/requiretty/!requiretty/g' /etc/sudoers
#
#USER ${USER}

#
# Installing libpng12 and libpng12-dev (which are missing in Ubuntu 18.04)
#
#RUN cd ${INSTALLDIR}/src && wget https://launchpad.net/~ubuntu-security/+archive/ubuntu/ppa/+build/15108504/+files/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb && \
#        sudo apt-get install -y ./libpng12-0_1.2.54-1ubuntu1.1_amd64.deb
#RUN cd ${INSTALLDIR}/src && wget http://security.ubuntu.com/ubuntu/pool/main/libp/libpng/libpng12-dev_1.2.54-1ubuntu1.1_amd64.deb && \
#        sudo apt-get install -y ./libpng12-dev_1.2.54-1ubuntu1.1_amd64.deb
#
# Installing libltdl-dev needed for Tempo2 in Ubuntu 16.04
#
RUN cd ${INSTALLDIR}/src && wget http://archive.ubuntu.com/ubuntu/pool/main/libt/libtool/libltdl-dev_2.4.6-0.1_amd64.deb && \
    sudo apt-get install ./libltdl-dev_2.4.6-0.1_amd64.deb && rm -f libltdl-dev_2.4.6-0.1_amd64.deb


# install boost python 1.63 with python2
RUN cd / && wget https://dl.bintray.com/boostorg/release/1.63.0/source/boost_1_63_0.tar.bz2 && \
        tar xvf boost_1_63_0.tar.bz2 && cd boost_1_63_0 && \
        ./bootstrap.sh --with-python=/usr/bin/python --with-libraries=python,date_time,filesystem,system,program_options,test && \
        ./b2 install && cd / && rm -r boost_1_63_0*

# install casacore data
RUN cd / && mkdir -p /opt/lofarsoft/data && cd /opt/lofarsoft/data && \
    wget ftp://anonymous@ftp.astron.nl/outgoing/Measures/WSRT_Measures.ztar && \
    tar xvf WSRT_Measures.ztar && rm WSRT_Measures.ztar

# install casacore v2.4.1
RUN cd / && wget https://github.com/casacore/casacore/archive/v2.4.1.tar.gz && \
        tar xvf v2.4.1.tar.gz && cd casacore-2.4.1 && mkdir build && cd build && \
        cmake -DBUILD_PYTHON=True -DDATA_DIR=/opt/lofarsoft/data -DUSE_OPENMP=ON -DUSE_THREADS=OFF -DUSE_FFTW3=TRUE -DUSE_HDF5=ON -DCXX11=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/lofarsoft/ -DCMAKE_CXX_FLAGS="-fsigned-char -O2 -DNDEBUG -march=native" ../ && \
        make -j4 && make install && cd ../../ && rm -rf casacore-2.4.1 v2.4.1.tar.gz

# install python casacore v3.2.0
RUN cd / && wget https://github.com/casacore/python-casacore/archive/v3.2.0.tar.gz && \
        tar xvf v3.2.0.tar.gz && cd python-casacore-3.2.0 && \
        python setup.py build_ext -I/opt/lofarsoft/include -L/opt/lofarsoft/lib/ && \
        mkdir -p /opt/lofarsoft/lib/python2.7/site-packages/ && \
        export PYTHONPATH=/opt/lofarsoft/lib/python2.7/site-packages/ && \
        python setup.py install --prefix=/opt/lofarsoft && cd ../ && rm -rf v3.2.0.tar.gz


#
# *******************
#   FFTW
# *******************
#
ARG FFTW_VERSION="3.3.9"

RUN cd ${INSTALLDIR}/src && sudo wget --retry-connrefused http://www.fftw.org/fftw-${FFTW_VERSION}.tar.gz && \
    sudo tar xvfz fftw-${FFTW_VERSION}.tar.gz && cd fftw-${FFTW_VERSION} && \
    sudo ./configure --prefix=${INSTALLDIR} --enable-shared --enable-threads --enable-single  --enable-sse --enable-sse2 --enable-avx --enable-avx2 && \
    sudo make && sudo make install && sudo make distclean && \
    sudo ./configure --prefix=${INSTALLDIR} --enable-shared --enable-threads --enable-sse2 --enable-avx --enable-avx2 && \
    sudo make && sudo make install && sudo make distclean && \
    sudo ./configure --prefix=${INSTALLDIR} --enable-shared --enable-threads --enable-long-double && \
    sudo make && sudo make install && sudo make distclean && \
    sudo ./configure --prefix=${INSTALLDIR} --enable-shared --enable-threads --enable-quad-precision && \
    sudo make && sudo make install && sudo make distclean && cd ../ && sudo rm -f fftw-${FFTW_VERSION}.tar.gz

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
    sudo make && sudo make install && sudo make distclean && cd ../ && sudo rm qt-x11-free-3.3.8b.tar.gz

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
    sudo install -D -m644 cpgplot.h ${INSTALLDIR}/include/cpgplot.h && cd ../ && sudo rm pgplot522.tar.gz

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

# *******************
#   TEMPO2
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone https://bitbucket.org/psrsoft/tempo2.git && cd tempo2 && \
    sudo ./bootstrap && \
    sudo cp -r T2runtime ${INSTALLDIR}/share/tempo2/
ENV TEMPO2="${INSTALLDIR}/share/tempo2/"
RUN cd ${INSTALLDIR}/src/tempo2 && sudo TEMPO2=${TEMPO2} ./configure --prefix=/usr/local && sudo make && sudo make install && \
    sudo make plugins && sudo make plugins-install && sudo make clean && sudo make distclean

#
# *******************
#   PSRCAT
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo wget --retry-connrefused http://www.atnf.csiro.au/people/pulsar/psrcat/downloads/psrcat_pkg.tar.gz && \
    sudo tar xvfz psrcat_pkg.tar.gz && cd psrcat_tar && sudo ./makeit && cd ${INSTALLDIR}/lib && \
    sudo ln -sf ${INSTALLDIR}/src/psrcat_tar/libpsrcat.a . && cd ${INSTALLDIR}/bin && \
    sudo ln -sf ${INSTALLDIR}/src/psrcat_tar/psrcat . && sudo ln -sf ${INSTALLDIR}/src/psrcat_tar/psrcat.db . && \
    sudo ln -sf ${INSTALLDIR}/src/psrcat_tar/glitch.db . && cd ../ && rm -f psrcat_pkg.tar.gz
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
    sudo cp libsigproc_linux.a ${INSTALLDIR}/lib && \
    sudo cp sigproc.h ${INSTALLDIR}/include && cd ../ && sudo rm -f sigproc-4.3.tar.gz
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
    sudo make PRESTO=${PRESTO} mpi
RUN cd ${PRESTO} && sudo PRESTO="${INSTALLDIR}/src/presto" PGPLOT_DIR="${INSTALLDIR}/lib" pip install --prefix=${INSTALLDIR} .
RUN cd ${PRESTO}/src && sudo make clean

#
# *******************
#   PSRDADA
# *******************
#
#RUN cd ${INSTALLDIR}/src && sudo cvs -z3 -d:pserver:anonymous@psrdada.cvs.sourceforge.net:/cvsroot/psrdada co -P psrdada && \
#    cd psrdada && sudo sed -i 's/mopsr\ //' Makefile.am && sudo ./bootstrap && \
#    sudo ./configure --prefix=${INSTALLDIR} --enable-shared --with-x && sudo make && sudo make install

RUN cd ${INSTALLDIR}/src && sudo git clone git://git.code.sf.net/p/psrdada/code psrdada && cd psrdada && \
    sudo sed -i 's/mopsr\ //' Makefile.am && sudo ./bootstrap && \
    sudo ./configure --prefix=${INSTALLDIR} --enable-shared --with-x && sudo make && sudo make install && sudo make distclean

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
    sudo make && sudo make install && sudo make distclean
ENV PSRCHIVE="${INSTALLDIR}"

#
# *******************
#   mark5access library
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone https://github.com/demorest/mark5access && cd mark5access && \
    sudo aclocal && sudo libtoolize --copy --force && sudo autoconf && sudo autoheader && sudo automake -a -c && \
    sudo ./configure --prefix=${INSTALLDIR} && sudo make && sudo make install && sudo make distclean

#
# *******************
#   DAL
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone https://github.com/nextgen-astrodata/DAL.git DAL && \
    cd DAL && sudo mkdir build && cd build && sudo cmake -DCMAKE_INSTALL_PREFIX=${INSTALLDIR} .. && \
    sudo make && sudo make install && cd ../ && sudo rm -rf build

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
    sudo make && sudo make install && sudo make distclean
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
    sudo ./prepare && sudo ./configure --prefix=${INSTALLDIR} && sudo make && sudo make install && sudo make distclean

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
    sudo sed -i "2iAntennaFieldDirectory=\"$antenna_field_dir\"" parseAntennaField.py && \
    sed -i "13s|\.\.|$INSTALLDIR\/src\/mscorpol|" ${INSTALLDIR}/src/mscorpol/mscorpol/HamakerJones.py
ENV MSCORPOL="${INSTALLDIR}/src/mscorpol"

#
# *******************
#   lofar_lta
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo wget http://www.astro-wise.org/losoft/lofar_lta-2.6.0.tar.gz && \
    sudo tar xvfz lofar_lta-2.6.0.tar.gz && cd lofar_lta-2.6.0 && \
    sudo python setup.py install_oracle --prefix=${INSTALLDIR} && \
    sudo python setup.py install --prefix=${INSTALLDIR} && cd ../ && sudo rm -f lofar_lta-2.6.0.tar.gz

#
# *******************
#   LOFAR-BF-pulsar-scripts
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone https://github.com/vkond/LOFAR-BF-pulsar-scripts && \
    cd LOFAR-BF-pulsar-scripts && \
    sudo cp subdyn.py ${INSTALLDIR}/bin && \
    cd FE-map && \
    sudo sed -i '28s/stations_file/#stations_file/' lofar_status_map.py && \
    statdir=`pwd` && sudo sed -i "29istations_file=\"$statdir/stations.txt\"" lofar_status_map.py && \
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
ENV LOFARSOFT="/opt/lofarsoft/usg"
RUN sudo mkdir -p ${LOFARSOFT} && cd ${LOFARSOFT} && sudo svn co http://usg.lofar.org/svn/code/trunk .
# installing 2bf2fits & bf2puma2 (just in case)
RUN cd ${LOFARSOFT}/src/Pulsar/apps && sudo rsync -avxP bf2format ${INSTALLDIR}/src/ && \
    cd ${INSTALLDIR}/src/bf2format && \
    sudo gcc  -DDEBUGGING_MESSAGES -DHAVE_CFITSIO -DHAVE_GLIB -DHAVE_PGPLOT -DHAVE_MPI -DHAVE_FFTW3 -O2 -I${INSTALLDIR}/include -o 2bf2fits.o -c 2bf2fits.c && \
    sudo gcc  -O2 2bf2fits.o  -o 2bf2fits -rdynamic -lm -lcfitsio && \
    sudo cp 2bf2fits ${INSTALLDIR}/bin && \
    sudo g++ bf2puma2.cpp -o bf2puma2 && \
    sudo cp bf2puma2 ${INSTALLDIR}/bin
# copying XML templates to /usr/local/etc/xml-templates,
# making the link to StaticMetaData in USG trunck in our /usr/local/etc
RUN cd ${INSTALLDIR}/etc && sudo mkdir xml-templates && sudo ln -sf ${LOFARSOFT}/data/lofar/StaticMetaData StaticMetaData && \
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
    sudo rm -rf ${LOFARSOFT}
ENV LOFARSOFT="/opt/lofarsoft"

# install RMextract v0.4
RUN cd / && git clone https://github.com/lofar-astron/RMextract.git && cd RMextract && \
        export PYTHONPATH=/opt/lofarsoft/lib/python2.7/site-packages/ && \
        python setup.py install --prefix=/opt/lofarsoft && cd / && rm -rf RMextract

# install RMCalc
RUN cd ${INSTALLDIR}/src && sudo mkdir -p RMCalc && cd RMCalc && sudo git clone https://gitlab.mpifr-bonn.mpg.de/nporayko/RMcalc.git .

#
# *******************
#   dreambeam
# *******************
#
RUN cd ${INSTALLDIR}/src && sudo git clone https://github.com/2baOrNot2ba/dreamBeam && cd ${INSTALLDIR}/src && \
    sudo chown -R root:root mscorpol && sudo chmod -R g+w mscorpol && \
    cd mscorpol/lofar_element_response && sudo make && \
    cd ../mscorpol && sudo sed -i '1s/AntennaFieldDirectory/#AntennaFieldDirectory/' parseAntennaField.py && \
    antenna_field_dir="${INSTALLDIR}/etc/StaticMetaData/AntennaFields/" && \
    sudo sed -i "2iAntennaFieldDirectory=\"$antenna_field_dir\"" parseAntennaField.py && \
    sed -i "13s|\.\.|$INSTALLDIR\/src\/mscorpol|" ${INSTALLDIR}/src/mscorpol/mscorpol/HamakerJones.py
ENV MSCORPOL="${INSTALLDIR}/src/mscorpol"

# install the LOFAR beam library
RUN cd / && git clone https://github.com/lofar-astron/LOFARBeam.git && cd LOFARBeam && \
        sed -i "710s|106200|106500|" /usr/share/cmake-3.5/Modules/FindBoost.cmake && \
        mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/opt/lofarsoft -DCMAKE_PREFIX_PATH=/opt/lofarsoft ../ && \
        make && make install && cd ../../ && rm -rf LOFARBeam

#
# ***********************
#  Updating psrchive.cfg
# ***********************
#
# running psrchive_config and put the config file to /usr/local/etc/psrchive.cfg
# and making necessary changes, such as
# FrequencyAppend::weight change from 'radiometer' to 'none'
# FrequencyAppend::force_new_predictor from 0 to 1
# Other necessary parameters seem now to have good values by default, i.e.
# Dispersion::barycentric_correction = 1
# WeightedFrequency::round_to_kHz = 0
# Predictor::default = tempo2
# Predictor::policy = default
ENV PSRCHIVE_CONFIG="${INSTALLDIR}/etc/psrchive.cfg"
#RUN sudo mkdir -p ${INSTALLDIR}/etc  && cd ${INSTALLDIR}/etc && sudo touch psrchive.cfg && sudo chown root:root psrchive.cfg && \
#    sudo chmod og+w psrchive.cfg && sudo -E ${INSTALLDIR}/bin/psrchive_config > psrchive.cfg && \
#    sudo sed -i 's/#\ FrequencyAppend::force_new_predictor\ =\ 0/FrequencyAppend::force_new_predictor\ =\ 1/' psrchive.cfg && \
#    sudo sed -i 's/FrequencyAppend::weight\ =\ radiometer/FrequencyAppend::weight\ =\ none/' psrchive.cfg
RUN sudo mkdir -p ${INSTALLDIR}/etc  && cd ${INSTALLDIR}/etc && sudo touch psrchive.cfg && sudo chown root:root psrchive.cfg && \
    sudo chmod og+w psrchive.cfg && sudo LD_LIBRARY_PATH=${LD_LIBRARY_PATH} ${INSTALLDIR}/bin/psrchive_config > psrchive.cfg && \
    sudo sed -i 's/^Dispersion::barycentric_correction/#Dispersion::barycentric_correction/' psrchive.cfg && \
    sudo sed -i '/^#.*Dispersion::barycentric_correction\ =/a Dispersion::barycentric_correction\ =\ 1' psrchive.cfg && \
    sudo sed -i 's/^WeightedFrequency::round_to_kHz/#WeightedFrequency::round_to_kHz/' psrchive.cfg && \
    sudo sed -i '/^#.*WeightedFrequency::round_to_kHz\ =/a WeightedFrequency::round_to_kHz\ =\ 0' psrchive.cfg && \
    sudo sed -i 's/^Predictor::default/#Predictor::default/' psrchive.cfg && \
    sudo sed -i '/^#.*Predictor::default\ =/a Predictor::default\ =\ tempo2' psrchive.cfg && \
    sudo sed -i 's/^Predictor::policy/#Predictor::policy/' psrchive.cfg && \
    sudo sed -i '/^#.*Predictor::policy\ =/a Predictor::policy\ =\ default' psrchive.cfg && \
    sudo sed -i 's/^FrequencyAppend::weight/#FrequencyAppend::weight/' psrchive.cfg && \
    sudo sed -i '/^#.*FrequencyAppend::weight\ =/a FrequencyAppend::weight\ =\ none' psrchive.cfg && \
    sudo sed -i 's/^FrequencyAppend::force_new_predictor/#FrequencyAppend::force_new_predictor/' psrchive.cfg && \
    sudo sed -i '/^#.*FrequencyAppend::force_new_predictor\ =/a FrequencyAppend::force_new_predictor\ =\ 1' psrchive.cfg

ENV PYTHONPATH="./:${PRESTO}/python:${INSTALLDIR}/bin:${INSTALLDIR}/src:${INSTALLDIR}/lib/python2.7/site-packages/:${INSTALLDIR}/lib/python2.7/dist-packages/:${INSTALLDIR}/src/coast_guard:${INSTALLDIR}/bin/lofar_antenna_state:${INSTALLDIR}/src/LOFAR-BF-pulsar-scripts/fluxcal:${MSCORPOL}/mscorpol:${PULP}:/opt/lofarsoft/lib/python2.7/site-packages/:${INSTALLDIR}/src/RMCalc"
ENV LD_LIBRARY_PATH="${PGPLOT_DIR}:${PRESTO}/lib:${INSTALLDIR}/lib:/usr/lib:${SIGPROC}:${TEMPO2}/lib:${INSTALLDIR}/lib64:${INSTALLDIR}/lib/instantclient_11_2:${INSTALLDIR}/src/dedisp-multi/lib:${INSTALLDIR}/src/dedisp/lib:/opt/lofarsoft/lib:/usr/local/lib/"
ENV PATH=".:${HOME}:${HOME}/bin:${INSTALLDIR}/bin:/opt/bin:${PRESTO}/bin:${SIGPROC}:${TEMPO}/src:${PGPLOT_DIR}:${TEMPO2}/bin:${SIGPROC}:${INSTALLDIR}/src/coast_guard:${INSTALLDIR}/bin/lofar_antenna_state:${INSTALLDIR}/src/LOFAR-BF-pulsar-scripts:${INSTALLDIR}/src/LOFAR-BF-pulsar-scripts/simple-sh-scripts:${INSTALLDIR}/src/LOFAR-BF-pulsar-scripts/scheduling:${INSTALLDIR}/src/LOFAR-BF-pulsar-scripts/fluxcal:${INSTALLDIR}/src/LOFAR-BF-pulsar-scripts/LTA:${INSTALLDIR}/src/LOFAR-BF-pulsar-scripts/FE-map:${MSCORPOL}/mscorpol:${MSCORPOL}/lofar_element_response:${PULP}:${INSTALLDIR}/src/RMCalc:${PATH}"

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
#COPY chuser.sh /usr/local/bin/chuser.sh
#WORKDIR ${HOME}
#ENTRYPOINT ["sudo","-E","/usr/local/bin/chuser.sh"]
