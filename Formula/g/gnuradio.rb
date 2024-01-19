class Gnuradio < Formula
  include Language::Python::Virtualenv

  desc "SDK for signal processing blocks to implement software radios"
  homepage "https:gnuradio.org"
  url "https:github.comgnuradiognuradioarchiverefstagsv3.10.9.2.tar.gz"
  sha256 "7fa154c423d01494cfa4c739faabad70b97f605238cd3fea8907b345b421fea1"
  license "GPL-3.0-or-later"
  head "https:github.comgnuradiognuradio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "672986e6fe589071243e8a911746ee5d9efa8615468ccd6e9a9c69bb131c8922"
    sha256 cellar: :any,                 arm64_ventura:  "7367931c4e898b8e6acec3224d5ad2af462793b8d9540cdd4b65e1d5a8c36733"
    sha256 cellar: :any,                 arm64_monterey: "99d22df92785403d7a28040e3d9e9ad556cbfedbd164d298be259d98bdad462b"
    sha256 cellar: :any,                 sonoma:         "194ae0d6d93e572c13d0cef00dbc13e70c18ecd3563f47d9d0cdee83984df16e"
    sha256 cellar: :any,                 ventura:        "7ed93debe74ce94823e7d9f02c64d6bf9d4e587fc945766a56d609c347879521"
    sha256 cellar: :any,                 monterey:       "35b2c594d06c3ba44e64c0b17a7a6453b41c0e4cb96d5893cad414d78b988a15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4657181218216528420a1ec7b429a98fc9c024c8c902ef086e07c4f5638d6bad"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "pybind11" => :build
  depends_on "adwaita-icon-theme"
  depends_on "boost"
  depends_on "cppzmq"
  depends_on "fftw"
  depends_on "gmp"
  depends_on "gsl"
  depends_on "gtk+3"
  depends_on "jack"
  depends_on "libsndfile"
  depends_on "libyaml"
  depends_on "log4cpp"
  depends_on "numpy"
  depends_on "portaudio"
  depends_on "pygments"
  depends_on "pygobject3"
  depends_on "pyqt@5"
  depends_on "python-click"
  depends_on "python-mako"
  depends_on "python-packaging"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "qt@5"
  depends_on "qwt-qt5"
  depends_on "six"
  depends_on "soapyrtlsdr"
  depends_on "spdlog"
  depends_on "uhd"
  depends_on "volk"
  depends_on "zeromq"

  fails_with gcc: "5"

  resource "cheetah3" do
    url "https:files.pythonhosted.orgpackages2333ace0250068afca106c1df34348ab0728e575dc9c61928d216de3e381c460Cheetah3-3.2.6.post1.tar.gz"
    sha256 "58b5d84e5fbff6cf8e117414b3ea49ef51654c02ee887d155113c5b91d761967"
  end

  resource "click-plugins" do
    url "https:files.pythonhosted.orgpackages5f1d45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  # pygccxml only published a .whl file on PyPi
  resource "pygccxml" do
    url "https:github.comCastXMLpygccxmlarchiverefstagsv2.4.0.tar.gz"
    sha256 "d59867809f8008ec48a5567a7203bb4c130ff203a8ddd708c945690749723c70"
  end

  def install
    python = "python3.11"
    ENV.cxx11

    ENV["XML_CATALOG_FILES"] = etc"xmlcatalog"

    venv_root = libexec"venv"
    site_packages = Language::Python.site_packages(python)
    ENV.prepend_create_path "PYTHONPATH", venv_rootsite_packages
    venv = virtualenv_create(venv_root, python)
    venv.pip_install resources

    # Avoid references to the Homebrew shims directory
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    qwt = Formula["qwt-qt5"].opt_lib
    qwt_lib = OS.mac? ? qwt"qwt.frameworkqwt" : qwt"libqwt.so"
    qwt_include = OS.mac? ? qwt"qwt.frameworkHeaders" : Formula["qwt-qt5"].opt_include

    args = %W[
      -DGR_PKG_CONF_DIR=#{etc}gnuradioconf.d
      -DGR_PREFSDIR=#{etc}gnuradioconf.d
      -DGR_PYTHON_DIR=#{prefixsite_packages}
      -DENABLE_DEFAULT=OFF
      -DPYTHON_EXECUTABLE=#{venv_root}binpython
      -DPYTHON_VERSION_MAJOR=3
      -DQWT_LIBRARIES=#{qwt_lib}
      -DQWT_INCLUDE_DIRS=#{qwt_include}
      -DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_lib}
      -DQT_BINARY_DIR=#{Formula["qt@5"].opt_bin}
      -DENABLE_TESTING=OFF
      -DENABLE_INTERNAL_VOLK=OFF
    ]

    enabled = %w[GNURADIO_RUNTIME GRC PYTHON VOLK]
    enabled_modules = %w[GR_ANALOG GR_AUDIO GR_BLOCKS GR_BLOCKTOOL
                         GR_CHANNELS GR_DIGITAL GR_DTV GR_FEC GR_FFT GR_FILTER
                         GR_MODTOOL GR_NETWORK GR_QTGUI GR_SOAPY GR_TRELLIS
                         GR_UHD GR_UTILS GR_VOCODER GR_WAVELET GR_ZEROMQ GR_PDU]
    (enabled + enabled_modules).each do |c|
      args << "-DENABLE_#{c}=ON"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Create a directory for Homebrew to put .pth files pointing to GNU Radio
    # plugins installed by other packages. An automatically-loaded module adds
    # this directory to the package search path.
    plugin_pth_dir = etc"gnuradioplugins.d"
    mkdir plugin_pth_dir

    venv_site_packages = venv_rootsite_packages

    (venv_site_packages"homebrew_gr_plugins.py").write <<~EOS
      import site
      site.addsitedir("#{plugin_pth_dir}")
    EOS

    pth_contents = "#{prefixsite_packages}\nimport homebrew_gr_plugins\n"
    (venv_site_packages"homebrew-gnuradio.pth").write pth_contents

    # Patch the grc config to change the search directory for blocks
    inreplace etc"gnuradioconf.dgrc.conf" do |s|
      s.gsub! share.to_s, "#{HOMEBREW_PREFIX}share"
    end

    rm bin.children.reject(&:executable?)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gnuradio-config-info -v")

    (testpath"test.c++").write <<~EOS
      #include <gnuradiotop_block.h>
      #include <gnuradioblocksnull_source.h>
      #include <gnuradioblocksnull_sink.h>
      #include <gnuradioblockshead.h>
      #include <gnuradiogr_complex.h>

      class top_block : public gr::top_block {
      public:
        top_block();
      private:
        gr::blocks::null_source::sptr null_source;
        gr::blocks::null_sink::sptr null_sink;
        gr::blocks::head::sptr head;
      };

      top_block::top_block() : gr::top_block("Top block") {
        long s = sizeof(gr_complex);
        null_source = gr::blocks::null_source::make(s);
        null_sink = gr::blocks::null_sink::make(s);
        head = gr::blocks::head::make(s, 1024);
        connect(null_source, 0, head, 0);
        connect(head, 0, null_sink, 0);
      }

      int main(int argc, char **argv) {
        top_block top;
        top.run();
      }
    EOS
    system ENV.cxx, testpath"test.c++", "-std=c++17", "-L#{lib}",
           "-lgnuradio-blocks", "-lgnuradio-runtime", "-lgnuradio-pmt",
           "-L#{Formula["boost"].opt_lib}", "-lboost_system",
           "-L#{Formula["log4cpp"].opt_lib}", "-llog4cpp",
           "-L#{Formula["fmt"].opt_lib}", "-lfmt",
           "-o", testpath"test"
    system ".test"

    (testpath"test.py").write <<~EOS
      from gnuradio import blocks
      from gnuradio import gr

      class top_block(gr.top_block):
          def __init__(self):
              gr.top_block.__init__(self, "Top Block")
              self.samp_rate = 32000
              s = gr.sizeof_gr_complex
              self.blocks_null_source_0 = blocks.null_source(s)
              self.blocks_null_sink_0 = blocks.null_sink(s)
              self.blocks_head_0 = blocks.head(s, 1024)
              self.connect((self.blocks_head_0, 0),
                           (self.blocks_null_sink_0, 0))
              self.connect((self.blocks_null_source_0, 0),
                           (self.blocks_head_0, 0))

      def main(top_block_cls=top_block, options=None):
          tb = top_block_cls()
          tb.start()
          tb.wait()

      main()
    EOS
    system Formula["python@3.11"].opt_bin"python3.11", testpath"test.py"
  end
end