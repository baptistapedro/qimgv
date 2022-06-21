FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev \
libqt5svg5-dev libexiv2-dev libmpv-dev libopencv-dev kimageformat-plugins 
RUN git clone https://github.com/easymodo/qimgv.git
WORKDIR /qimgv
RUN cmake -DCMAKE_C_COMPILER=afl-clang -DCMAKE_CXX_COMPILER=afl-clang++ .
RUN make
RUN make install
RUN mkdir /qimgvCorpus
RUN wget https://filesamples.com/samples/image/png/sample_640%C3%97426.png
RUN wget https://www.fnordware.com/superpng/pnggrad16rgb.png
RUN wget https://www.fnordware.com/superpng/pnggrad8rgb.png
RUN mv *.png /qimgvCorpus
ENV LD_LIBRARY_PATH=/usr/local/lib

ENTRYPOINT ["afl-fuzz", "-i", "/qimgvCorpus", "-o", "/qimgvOut"]
CMD ["/qimgv/qimgv/qimgv", "@@"]
