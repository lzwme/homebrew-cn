class Gnuradio < Formula
  include Language::Python::Virtualenv

  desc "SDK for signal processing blocks to implement software radios"
  homepage "https://gnuradio.org/"
  url "https://ghproxy.com/https://github.com/gnuradio/gnuradio/archive/refs/tags/v3.10.7.0.tar.gz"
  sha256 "55156650ada130600c70bc2ab38eee718fc1d23011be548471e888399f207ddc"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/gnuradio/gnuradio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "be08dcbfafa9b3c81e1804848f79a7a45b3d2c6a8c70945f80fcc06dcef5a943"
    sha256 cellar: :any,                 arm64_ventura:  "829a21cb292ac87b269aefd66390f0f85bdab0f874569bbb7aa02b9de59d2784"
    sha256 cellar: :any,                 arm64_monterey: "60ab3c88b090e2fb13042503b708332fab7d40c585e1147903bdd1c12f3b4766"
    sha256 cellar: :any,                 sonoma:         "4665bded6a476a3c330adf27c552d3bfbc934856acf1487e87b0ae9f6ed1c07e"
    sha256 cellar: :any,                 ventura:        "6e0073f701748806b4d0d3746de00957696487737470d1c5f6061c2e2a4733d5"
    sha256 cellar: :any,                 monterey:       "4bbd2450a3dd98d597f91e2e45e60ca31268f5b1a5e15fcad82bd9a1c5c1ad89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f1bbc535e8a148362695e13deba0e23a1b3f5fdc2815e1754cd9181f7287b9b"
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
    url "https://files.pythonhosted.org/packages/ee/6f/29c6d74d8536dede06815eeaebfad53699e3f3df0fb22b7a9801a893b426/Cheetah3-3.2.6.tar.gz"
    sha256 "f1c2b693cdcac2ded2823d363f8459ae785261e61c128d68464c8781dba0466b"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  # pygccxml only published a .whl file on PyPi
  resource "pygccxml" do
    url "https://ghproxy.com/https://github.com/CastXML/pygccxml/archive/refs/tags/v2.2.1.tar.gz"
    sha256 "9815a12e3bf6b83b2e9d8c88335fb3fa0e2b4067d7fbaaed09c3bf26c6206cc7"
  end

  def install
    python = "python3.11"
    ENV.cxx11

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    venv_root = libexec/"venv"
    site_packages = Language::Python.site_packages(python)
    ENV.prepend_create_path "PYTHONPATH", venv_root/site_packages
    venv = virtualenv_create(venv_root, python)
    venv.pip_install resources

    # Avoid references to the Homebrew shims directory
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    qwt = Formula["qwt-qt5"].opt_lib
    qwt_lib = OS.mac? ? qwt/"qwt.framework/qwt" : qwt/"libqwt.so"
    qwt_include = OS.mac? ? qwt/"qwt.framework/Headers" : Formula["qwt-qt5"].opt_include

    args = %W[
      -DGR_PKG_CONF_DIR=#{etc}/gnuradio/conf.d
      -DGR_PREFSDIR=#{etc}/gnuradio/conf.d
      -DGR_PYTHON_DIR=#{prefix/site_packages}
      -DENABLE_DEFAULT=OFF
      -DPYTHON_EXECUTABLE=#{venv_root}/bin/python
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
    plugin_pth_dir = etc/"gnuradio/plugins.d"
    mkdir plugin_pth_dir

    venv_site_packages = venv_root/site_packages

    (venv_site_packages/"homebrew_gr_plugins.py").write <<~EOS
      import site
      site.addsitedir("#{plugin_pth_dir}")
    EOS

    pth_contents = "#{prefix/site_packages}\nimport homebrew_gr_plugins\n"
    (venv_site_packages/"homebrew-gnuradio.pth").write pth_contents

    # Patch the grc config to change the search directory for blocks
    inreplace etc/"gnuradio/conf.d/grc.conf" do |s|
      s.gsub! share.to_s, "#{HOMEBREW_PREFIX}/share"
    end

    rm bin.children.reject(&:executable?)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnuradio-config-info -v")

    (testpath/"test.c++").write <<~EOS
      #include <gnuradio/top_block.h>
      #include <gnuradio/blocks/null_source.h>
      #include <gnuradio/blocks/null_sink.h>
      #include <gnuradio/blocks/head.h>
      #include <gnuradio/gr_complex.h>

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
    system ENV.cxx, testpath/"test.c++", "-std=c++11", "-L#{lib}",
           "-lgnuradio-blocks", "-lgnuradio-runtime", "-lgnuradio-pmt",
           "-L#{Formula["boost"].opt_lib}", "-lboost_system",
           "-L#{Formula["log4cpp"].opt_lib}", "-llog4cpp",
           "-L#{Formula["fmt"].opt_lib}", "-lfmt",
           "-o", testpath/"test"
    system "./test"

    (testpath/"test.py").write <<~EOS
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
    system Formula["python@3.11"].opt_bin/"python3.11", testpath/"test.py"
  end
end