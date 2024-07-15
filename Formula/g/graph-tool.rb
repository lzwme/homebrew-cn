class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https:graph-tool.skewed.de"
  # TODO: Update build for matplotlib>=3.9.0 to use `--config-settings=setup-args=...` for system dependencies
  url "https:downloads.skewed.degraph-toolgraph-tool-2.72.tar.bz2"
  sha256 "7c89c4cf26ae24f4e3394e17011d139080dba408e58beae9cc7fbe8b3b6e9c74"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https:downloads.skewed.degraph-tool"
    regex(href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256                               arm64_sonoma:   "a7182c401f27711457be9d1f6959292f7cd297898e3ad4ae1d0d4d5aa0e1789a"
    sha256                               arm64_ventura:  "a36b759ccc255960dfe93eaf1c02147176218473dc563bed22ce406b7b8b8abe"
    sha256                               arm64_monterey: "29a8c043f8f046678dbbe99c6076aba5880e2ac08c8487c36f7d9f22aa412fe6"
    sha256                               sonoma:         "e75e57aef77131a94ef784d958d250a1bd861823bde135b1867179dbabf10d15"
    sha256                               ventura:        "da1fc1ffe8a816c167cdc23574a33fa9e8b6e5aa9e6fdfe624715699ff368f0c"
    sha256                               monterey:       "210c0c4f7cec976d0290e6d9ce056cc42bf2d1261f67d9bcb0e33b2ae4ae20a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cb761dea58d28d41b75605a5d8b27508160172f1496f2096bd8be0396c82f8c"
  end

  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "cairomm@1.14"
  depends_on "cgal"
  depends_on "freetype"
  depends_on "gmp"
  depends_on "google-sparsehash"
  depends_on "gtk+3"
  depends_on macos: :mojave # for C++17
  depends_on "numpy"
  depends_on "pillow"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.12"
  depends_on "qhull"
  depends_on "scipy"
  depends_on "zstd"

  uses_from_macos "expat"

  on_macos do
    depends_on "cairo"
    depends_on "libsigc++@2"
  end

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "contourpy" do
    url "https:files.pythonhosted.orgpackages8d9ee4786569b319847ffd98a8326802d5cf8a5500860dbfc2df1f0f4883ed99contourpy-1.2.1.tar.gz"
    sha256 "4d8908b3bee1c889e547867ca4cdc54e5ab6be6d3e078556814a22457f49423c"
  end

  resource "cycler" do
    url "https:files.pythonhosted.orgpackagesa995a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https:files.pythonhosted.orgpackagesc6cbcd80a0da995adde8ade6044a8744aee0da5efea01301cadf770f7fbe7dccfonttools-4.53.1.tar.gz"
    sha256 "e128778a8e9bc11159ce5447f76766cefbd876f44bd79aff030287254e4752c4"
  end

  resource "kiwisolver" do
    url "https:files.pythonhosted.orgpackagesb92d226779e405724344fc678fcc025b812587617ea1a48b9442628b688e85eakiwisolver-1.4.5.tar.gz"
    sha256 "e57e563a57fb22a142da34f38acc2fc1a5c864bc29ca1517a88abc963e60d6ec"
  end

  resource "matplotlib" do
    url "https:files.pythonhosted.orgpackages22069e8ba6ec8b716a215404a5d1938b61f5a28001be493cf35344dda9a4072amatplotlib-3.9.1.tar.gz"
    sha256 "de06b19b8db95dd33d0dc17c926c7c9ebed9f572074b6fac4f65068a6814d010"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages463a31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages65d810a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "zstandard" do
    url "https:files.pythonhosted.orgpackages5d912162ab4239b3bd6743e8e407bc2442fca0d326e2d77b3f4a88d90ad5a1fazstandard-0.22.0.tar.gz"
    sha256 "8226a33c542bcb54cd6bd0a366067b610b41713b64c9abec1bc4533d69f51e70"
  end

  def python3
    "python3.12"
  end

  def install
    # https:github.commatplotlibmatplotlibblobv3.8.3docusersinstallingdependencies.rst
    ENV["MPLSETUPCFG"] = buildpath"mplsetup.cfg"
    (buildpath"mplsetup.cfg").write <<~EOS
      [libs]
      system_freetype = true
      system_qhull = true
    EOS

    site_packages = Language::Python.site_packages(python3)
    xy = Language::Python.major_minor_version(python3)
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| r.name == "zstandard" }
    resource("zstandard").stage do
      system_zstd_arg = "--config-settings=--build-option=--system-zstd"
      system venv.root"binpython3", "-m", "pip", "install", system_zstd_arg, *std_pip_args, "."
    end

    # Linux build is not thread-safe.
    ENV.deparallelize unless OS.mac?

    args = %W[
      PYTHON=#{venv.root}binpython
      --with-python-module-path=#{prefixsite_packages}
      --with-boost-python=boost_python#{xy.to_s.delete(".")}-mt
      --with-boost-libdir=#{Formula["boost"].opt_lib}
      --with-boost-coroutine=boost_coroutine-mt
      --disable-silent-rules
    ]
    args << "PYTHON_LIBS=-undefined dynamic_lookup" if OS.mac?

    system ".configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      Only the main library is linked to avoid contaminating the shared site-packages.
      Graph drawing and other features that require extra Python packages may be used
      by adding the following formula-specific site-packages to your PYTHONPATH:
        #{opt_libexecLanguage::Python.site_packages(python3)}
    EOS
  end

  test do
    (testpath"test.py").write <<~EOS
      import graph_tool.all as gt
      g = gt.Graph()
      v1 = g.add_vertex()
      v2 = g.add_vertex()
      e = g.add_edge(v1, v2)
      assert g.num_edges() == 1
      assert g.num_vertices() == 2
    EOS
    assert_match "Graph drawing will not work", shell_output("#{python3} test.py 2>&1")
    ENV["PYTHONPATH"] = libexecLanguage::Python.site_packages(python3)
    refute_match "Graph drawing will not work", shell_output("#{python3} test.py 2>&1")
  end
end