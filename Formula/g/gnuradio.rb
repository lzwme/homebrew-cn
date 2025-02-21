class Gnuradio < Formula
  include Language::Python::Virtualenv

  desc "SDK for signal processing blocks to implement software radios"
  homepage "https:www.gnuradio.org"
  url "https:github.comgnuradiognuradioarchiverefstagsv3.10.12.0.tar.gz"
  sha256 "fe78ad9f74c8ebf93d5c8ad6fa2c13236af330f3c67149d91a0647b3dc6f3958"
  license "GPL-3.0-or-later"
  head "https:github.comgnuradiognuradio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ce8a40fccb766d26fff338eddd403b74cf6ef5df3660cfd4112c97874071617"
    sha256 cellar: :any,                 arm64_sonoma:  "1d94820f8c757bdb999b72974e8ab20aada2665993fa593621b79b0aeec6d49a"
    sha256 cellar: :any,                 arm64_ventura: "d6b6b21ca113c0be63f97f798a6c4d7524d180cccb753e511f243dabbf6da854"
    sha256 cellar: :any,                 sonoma:        "21dc5154d0e5dac2af2996072c42fd352e372a53f2d34478f5884ffcc9519080"
    sha256 cellar: :any,                 ventura:       "c5f502111a876a6d8dd033b19a97d9cf1055e08ade0ffb4c3fe1809af290e4eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c665ac786d58e1a893c60aadbf6ae81f3bdaf368ece894e4e0f3887e632bb73a"
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
  depends_on "python@3.13"
  depends_on "qt@5" # Qt6 issue: https:github.comgnuradiognuradioissues7708
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
  # * jsonschema - grcblocksjson_config.block.yml
  # * lxml - grcconverterxml.py
  # * mako - grc
  # * packaging - CMakeLists.txt
  # * pygccxml - gr-utilsblocktoolcoreparseheader.py
  # * pyyaml - grc
  # * setuptools - gr-utilsmodtoolclibase.py

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages497cfdf464bcc51d23881d110abd74b512a42b3d5d376a55a831b44c603ae17fattrs-25.1.0.tar.gz"
    sha256 "1c97078a80c814273a76b2a298a932eb681c87415c11dee0a6921de7f1b02c3e"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackages10db58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackageseff6c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  resource "mako" do
    url "https:files.pythonhosted.orgpackages624fddb1965901bc388958db9f0c991255b2c469349a741ae8c9cd8a562d70a6mako-1.3.9.tar.gz"
    sha256 "b5d65ff3462870feec922dbccf38f6efb44e5714d7b593a656be86663d8600ac"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pygccxml" do
    url "https:files.pythonhosted.orgpackages2644a9fef507f807be838fa0991517df226abd26233cf75fb8d4e97970552174pygccxml-2.6.1.tar.gz"
    sha256 "fc1b483c91848dada921efbe0e172648e2c6aa42d78ec920a372375e4ee32841"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages2fdb98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages0180cce854d0921ff2f0a9fa831ba3ad3c65cee3a46711addf39a2af52df2cfdrpds_py-0.22.3.tar.gz"
    sha256 "e32fee8ab45d3c2db6da19a5323bc3362237c8b653c70194414b892fd06a080d"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages92ec089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
  end

  def python3
    "python3.13"
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

    boost = Formula["boost"]
    system ENV.cxx, testpath"test.c++", "-std=c++17", "-I#{boost.opt_include}", "-L#{lib}",
           "-lgnuradio-blocks", "-lgnuradio-runtime", "-lgnuradio-pmt",
           "-L#{boost.opt_lib}", "-lboost_system",
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