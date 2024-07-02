class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https:graph-tool.skewed.de"
  # TODO: Update build for matplotlib>=3.9.0 to use `--config-settings=setup-args=...` for system dependencies
  url "https:downloads.skewed.degraph-toolgraph-tool-2.71.tar.bz2"
  sha256 "315784100c6f73a7c49906ad9539fd5c608e4cd91c0aff28b8d6d8a8bebd03c5"
  license "LGPL-3.0-or-later"
  revision 1

  livecheck do
    url "https:downloads.skewed.degraph-tool"
    regex(href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256                               arm64_sonoma:   "7a3b4a82bfe8251fbe5ebbb5fa4d323d299cc6bacfa4fff03f32bd48a9a11d25"
    sha256                               arm64_ventura:  "a612b898329dfa7713fef7668ee7b00a5814a56c44615fa388a30cc3f2a5bc66"
    sha256                               arm64_monterey: "e789f6b23ef2ff445d9aac1ade88bda27f35887219f9ae23cb749764700ad9d1"
    sha256                               sonoma:         "634a8998e59d0d4ad7331ff83c9e1ecd0d4889ec3f7f2e2a75b85be68183c4aa"
    sha256                               ventura:        "94851f972438edd35dacbd2e7fc10567134a0ec6e5691421b464093ecdda9ebe"
    sha256                               monterey:       "333134d9bb7caed2ea0fbdecc7e7d1051f38601425b935390c54a54d5d1a5ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a4dee2a723194e3de3cd0a134e50ad3294c1168e2adce1150c36dc6b04d9b3a"
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
    url "https:files.pythonhosted.orgpackagesa46e681d39b71d5f0d6a1b1dc87d7333331f9961b5ab6a2ad6372d6cf3f8b04cfonttools-4.53.0.tar.gz"
    sha256 "c93ed66d32de1559b6fc348838c7572d5c0ac1e4a258e76763a5caddd8944002"
  end

  resource "kiwisolver" do
    url "https:files.pythonhosted.orgpackagesb92d226779e405724344fc678fcc025b812587617ea1a48b9442628b688e85eakiwisolver-1.4.5.tar.gz"
    sha256 "e57e563a57fb22a142da34f38acc2fc1a5c864bc29ca1517a88abc963e60d6ec"
  end

  resource "matplotlib" do
    url "https:files.pythonhosted.orgpackagesc5a4a7236bf8b0137deff48737c6ccf2154ef4486e57c6a5b7c309bf515992bdmatplotlib-3.9.0.tar.gz"
    sha256 "e6d29ea6c19e34b30fb7d88b7081f869a03014f66fe06d62cc77d5a6ea88ed7a"
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
    url "https:files.pythonhosted.orgpackages0d9dc587bea18a7e40099857015baee4cece7aca32cd404af953bdeb95ac8e47setuptools-70.1.1.tar.gz"
    sha256 "937a48c7cdb7a21eb53cd7f9b59e525503aa8abaf3584c730dc5f7a5bec3a650"
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