class Networkit < Formula
  desc "Performance toolkit for large-scale network analysis"
  homepage "https:networkit.github.io"
  url "https:github.comnetworkitnetworkitarchiverefstags11.0.tar.gz"
  sha256 "3cba54b384db4adfd88c984805647a3b74ed52168b6178cba6dd58f1cbd73120"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "81949acfa3065cfbbe5faa3b36e330933236a0c30e140a50b7400cde3171659d"
    sha256 cellar: :any,                 arm64_ventura:  "6bcfd6165aa1ffd664366a0332bd65ce243094c40d1b63fe24462658d62e2d1f"
    sha256 cellar: :any,                 arm64_monterey: "5fcae28e49883d22df3dc2bb97be716ac0737c034879beefe2c7034b0571201d"
    sha256 cellar: :any,                 sonoma:         "74584f6e8f6e4a0ce0e56d3c2b9f4782d876c5f5261a0dba45bb60bfb32bbb5e"
    sha256 cellar: :any,                 ventura:        "7ef54d95f47df44e4461d3efa6641b327497acec7dcfdc6c1c044a4600ce5195"
    sha256 cellar: :any,                 monterey:       "961902133e55e13836d0032151b6803f7f1759eb9ed8c680b6a2f95eb6d5039c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64835847af612a11dc878b6b46b8330133b2c8034c118198feb955ef36a8a2e1"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on "tlx" => :build

  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "scipy"

  on_macos do
    depends_on "libomp"
  end

  def python3
    which("python3.12")
  end

  # Add compat for numpy 2.0
  patch do
    url "https:github.comnetworkitnetworkitcommit165503580caac864c7a31558b4c5fee27bcb007e.patch?full_index=1"
    sha256 "67bd2d1fe3ebccb42ccdd1f7cf5aeea40967caa4e9bc96cc69737dc14ffa9654"
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
    system python3, "-c", <<~EOS
      import networkit as nk
      G = nk.graph.Graph(3)
      G.addEdge(0,1)
      G.addEdge(1,2)
      G.addEdge(2,0)
      assert G.degree(0) == 2
      assert G.degree(1) == 2
      assert G.degree(2) == 2
    EOS
  end
end