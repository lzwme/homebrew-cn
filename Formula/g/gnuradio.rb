class Gnuradio < Formula
  include Language::Python::Virtualenv

  desc "SDK for signal processing blocks to implement software radios"
  homepage "https:gnuradio.org"
  url "https:github.comgnuradiognuradioarchiverefstagsv3.10.11.0.tar.gz"
  sha256 "9ca658e6c4af9cfe144770757b34ab0edd23f6dcfaa6c5c46a7546233e5ecd29"
  license "GPL-3.0-or-later"
  revision 1
  head "https:github.comgnuradiognuradio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d8c90b4a37295e286c4922b1c8ec7d845a8a3a0a0c27ab32b8d5530979143dfe"
    sha256 cellar: :any,                 arm64_sonoma:  "06ac8da03aaca3d8f6fdede63295234259120c9cab34c58d22702f7ae8ed18b6"
    sha256 cellar: :any,                 arm64_ventura: "72fba0972648f34a1f5e3e1887c05f64e18806bed4fe8ac4392de8c9572fc1c6"
    sha256 cellar: :any,                 sonoma:        "3ae3eba4b90095e3262475be620845da0224e8db8046feffa8f5da3766ac4385"
    sha256 cellar: :any,                 ventura:       "8612ccf79c75479767dd5a40ba092b29acaa70e805503fb77fdf6c26f2dcd67a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d9b4fbb8b410cced6bffe53dca172e4df0ff3cbba8ef4be1bd729445da7d60b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build
  depends_on "rust" => :build # for rpds-py
  depends_on "adwaita-icon-theme"
  depends_on "boost"
  depends_on "cppzmq"
  depends_on "fftw"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "gsl"
  depends_on "gtk+3"
  depends_on "jack"
  depends_on "libsndfile"
  depends_on "libyaml"
  depends_on "log4cpp"
  depends_on "numpy"
  depends_on "portaudio"
  depends_on "pygobject3"
  depends_on "pyqt@5"
  depends_on "python@3.12"
  depends_on "qt@5"
  depends_on "qwt-qt5"
  depends_on "soapyrtlsdr"
  depends_on "soapysdr"
  depends_on "spdlog"
  depends_on "uhd"
  depends_on "volk"
  depends_on "zeromq"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "alsa-lib"
    depends_on "llvm"
  end

  # Resources for Python packages based on .condarecipemeta.yaml
  # Currently skipping `matplotlib` and `scipy` extra dependencies.
  #
  # The following are paths where packages are used:
  # * click - gr-utilsmodtoolcli
  # * click-plugins - gr-utilsmodtoolclibase.py
  # * jsonschema - grcblocksjson_config.block.yml
  # * lxml - grcconverterxml.py
  # * mako - grc
  # * packaging - CMakeLists.txt
  # * pygccxml - gr-utilsblocktoolcoreparseheader.py
  # * pyyaml - grc
  # * setuptools - gr-utilsmodtoolclibase.py

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-plugins" do
    url "https:files.pythonhosted.orgpackages5f1d45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages4dc53f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9bejsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages2bb4bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "mako" do
    url "https:files.pythonhosted.orgpackagesd41b71434d9fa9be1ac1bc6fb5f54b9d41233be2969f16be759766208f49f072Mako-1.3.2.tar.gz"
    sha256 "2a0c8ad7f6274271b3bb7467dd37cf9cc6dab4bc19cb69a4ef10669402de698e"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pygccxml" do
    url "https:files.pythonhosted.orgpackagesa76626fd5b200172161de3d903b87a3ec9c6764bc6c6895744a57070790ea2aapygccxml-2.4.0.tar.gz"
    sha256 "831d670c9829635a4f2fe1ff1e92d1e2bfbdebc16179f1ce7f4c3ce1762f1cb3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages21c5b99dd501aa72b30a5a87d488d7aa76ec05bdf0e2c7439bc82deb9448dd9areferencing-0.33.0.tar.gz"
    sha256 "c775fedf74bc0f9189c2a3be1c12fd03e8c23f4d371dce795df44e06c5b412f7"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages55bace7b9f0fc5323f20ffdf85f682e51bee8dc03e9b54503939ebb63d1d0d5erpds_py-0.18.0.tar.gz"
    sha256 "42821446ee7a76f5d9f71f9e33a4fb2ffd724bb3e7f93386150b61a43115788d"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc81fe026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  def python3
    "python3.12"
  end

  def install
    ENV.cxx11
    ENV["XML_CATALOG_FILES"] = etc"xmlcatalog"

    site_packages = Language::Python.site_packages(python3)
    venv = virtualenv_create(libexec"venv", python3)
    venv.pip_install resources
    ENV.prepend_create_path "PYTHONPATH", venv.rootsite_packages

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
      -DPYTHON_EXECUTABLE=#{venv.root}binpython
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
    plugin_pth_dir.mkpath

    (venv.site_packages"homebrew_gr_plugins.py").write <<~PYTHON
      import site
      site.addsitedir("#{plugin_pth_dir}")
    PYTHON

    pth_contents = "#{prefixsite_packages}\nimport homebrew_gr_plugins\n"
    (venv.site_packages"homebrew-gnuradio.pth").write pth_contents

    # Patch the grc config to change the search directory for blocks
    inreplace etc"gnuradioconf.dgrc.conf", share.to_s, "#{HOMEBREW_PREFIX}share"

    bin.children.reject(&:executable?).map(&:unlink)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gnuradio-config-info -v")

    (testpath"test.c++").write <<~CPP
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
    CPP
    system ENV.cxx, testpath"test.c++", "-std=c++17", "-L#{lib}",
           "-lgnuradio-blocks", "-lgnuradio-runtime", "-lgnuradio-pmt",
           "-L#{Formula["boost"].opt_lib}", "-lboost_system",
           "-L#{Formula["log4cpp"].opt_lib}", "-llog4cpp",
           "-L#{Formula["fmt"].opt_lib}", "-lfmt",
           "-o", testpath"test"
    system ".test"

    (testpath"test.py").write <<~PYTHON
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
    PYTHON
    system python3, testpath"test.py"
  end
end