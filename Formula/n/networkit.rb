class Networkit < Formula
  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://ghfast.top/https://github.com/networkit/networkit/archive/refs/tags/11.1.tar.gz"
  sha256 "c8db0430f6d7503eaf1e59fbf181374dc9eaa70f572c56d2efa75dd19a3548a9"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eea2f6104c4737420512d88437d0181430254e9349a674d6eae84850a97a697b"
    sha256 cellar: :any, arm64_sequoia: "4cb1ea5c0169d17ac2c6c75cd0cca09baa274a76823d5aa93beed997b0d25b2e"
    sha256 cellar: :any, arm64_sonoma:  "9847f90f7fa1fed977b6e4931ec2c886600114a8222c7931e6ba52d747f12fb3"
    sha256 cellar: :any, sonoma:        "8e40e5d67717edec14a48dc7895d73c65ee82da6afb562e1352b890a2d997c5c"
    sha256               arm64_linux:   "900374b83c60b1885e5e0a90047935ae08d89d34caca37f9b291efff351c6c6a"
    sha256               x86_64_linux:  "13aa55d4f8306d980d6109a5e77c3bd855278f44fc8293861348c3165bdd0f3a"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on "tlx" => :build

  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "scipy"

  on_macos do
    depends_on "libomp"
  end

  def python3
    which("python3.14")
  end

  def install
    # Fix to networkit/graphtools.pyx:408:17: Can only parameterize template functions.
    # Issue ref: https://github.com/networkit/networkit/issues/1350
    inreplace "networkit/graphtools.pyx", "return volume[vector[node].iterator]", "return volume"

    site_packages = Language::Python.site_packages(python3)

    ENV.prepend_create_path "PYTHONPATH", prefix/site_packages
    ENV.append_path "PYTHONPATH", Formula["cython"].opt_libexec/site_packages

    networkit_site_packages = prefix/site_packages/"networkit"
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