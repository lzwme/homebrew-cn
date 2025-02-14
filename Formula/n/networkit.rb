class Networkit < Formula
  desc "Performance toolkit for large-scale network analysis"
  homepage "https:networkit.github.io"
  url "https:github.comnetworkitnetworkitarchiverefstags11.0.1.tar.gz"
  sha256 "fbdc86b6ac6486ce4e0898f386c5371bd07b9a420293306f2e632549378f4b86"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e2e46abe8a139444c007427c3274477679059c5b8a4193dc9e448470c0d7b12a"
    sha256 cellar: :any,                 arm64_sonoma:  "8286df44e96a2d384adb8c516771cb8f378d8a951ceb5f92c1c9ea0950f53e1e"
    sha256 cellar: :any,                 arm64_ventura: "6096292d1c1f3541228a90a376168871956b9f1bde1adf29721bc42ca0215eed"
    sha256 cellar: :any,                 sonoma:        "59c725a50e5dca22f434f78ee172454dbe8c33356c6d89f765a53e3a4ca3a618"
    sha256 cellar: :any,                 ventura:       "ee91d3e7326708b2285b1b9448d7437a29d52a85c69125a114648a375f563b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "428bb5a7ce28317e629968d05ba61368287fce55b1f77622ab6a210ed8d5cfef"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on "tlx" => :build

  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "scipy"

  on_macos do
    depends_on "libomp"
  end

  def python3
    which("python3.13")
  end

  def install
    site_packages = Language::Python.site_packages(python3)

    ENV.prepend_create_path "PYTHONPATH", prefixsite_packages
    ENV.append_path "PYTHONPATH", Formula["cython"].opt_libexecsite_packages

    networkit_site_packages = prefixsite_packages"networkit"
    extra_rpath = rpath(source: networkit_site_packages, target: Formula["libnetworkit"].opt_lib)
    system python3, "setup.py", "build_ext", "--networkit-external-core",
                                             "--external-tlx=#{Formula["tlx"].opt_prefix}",
                                             "--rpath=#{loader_path};#{extra_rpath}"

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system python3, "-c", <<~PYTHON
      import networkit as nk
      G = nk.graph.Graph(3)
      G.addEdge(0,1)
      G.addEdge(1,2)
      G.addEdge(2,0)
      assert G.degree(0) == 2
      assert G.degree(1) == 2
      assert G.degree(2) == 2
    PYTHON
  end
end