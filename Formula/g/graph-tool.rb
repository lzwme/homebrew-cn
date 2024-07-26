class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https:graph-tool.skewed.de"
  # TODO: Update build for matplotlib>=3.9.0 to use `--config-settings=setup-args=...` for system dependencies
  url "https:downloads.skewed.degraph-toolgraph-tool-2.74.tar.bz2"
  sha256 "ed19a45c050663d342e0b28fcc985d513908ea573d86c940a7907900d3e02a6e"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https:downloads.skewed.degraph-tool"
    regex(href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256                               arm64_sonoma:   "39255e3dfdcb7a449be42706a54016202a7f9ce65bc2e9922c7f01ebd5de202d"
    sha256                               arm64_ventura:  "9d3214d60e3eacd4c4b765e9cfc80fefbf845bf32faf593739d7ec80859ef0e0"
    sha256                               arm64_monterey: "8a30bd0547ced08c954d2af2091bb38bf04b8958bf60c07cdbde679edaece09d"
    sha256                               sonoma:         "537011ce353b49d1d36c91a41df62f3d42b6a1329258570998b01137804c7fc5"
    sha256                               ventura:        "c17a7da0694610c7c42114637e4e77db57974f9413e2d1f0572ade10a916c4b8"
    sha256                               monterey:       "3d8f57ae240eb5297b9308ca34ae18578b9134ffd149803173973fb181685b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0993ceee1db71fe47a1416a1a9026c288f473370ff17af904e91eec643c782e9"
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
    url "https:files.pythonhosted.orgpackages32c05b8013b5a812701c72e3b1e2b378edaa6514d06bee6704a5ab0d7fa52931setuptools-71.1.0.tar.gz"
    sha256 "032d42ee9fb536e33087fb66cac5f840eb9391ed05637b3f2a76a7c8fb477936"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "zstandard" do
    url "https:files.pythonhosted.orgpackagesedf62ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
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