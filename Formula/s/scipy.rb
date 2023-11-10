class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/39/7b/9f265b7f074195392e893a5cdc66116c2f7a31fd5f3d9cceff661ec6df82/scipy-1.11.3.tar.gz"
  sha256 "bba4d955f54edd61899776bad459bf7326e14b9fa1c552181f0479cc60a568cd"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "28e42a4a4aa3ef3607305e4e9f8d5552a1ccedb390f2186bc2df9ce14cc0a1e5"
    sha256 cellar: :any,                 arm64_ventura:  "9c9828c4697fcf7c63b0712107b7357ed783c826336560a6013dfacab236b19d"
    sha256 cellar: :any,                 arm64_monterey: "e364186b50e4ed108c29d6fb66b069b1aee2291323e7f551e2c04a13f9229627"
    sha256 cellar: :any,                 sonoma:         "f025e479e90fe41a240faa9b0d1e12988068ec3b29c04ec96af4692087d5ba01"
    sha256 cellar: :any,                 ventura:        "31f4904d87bea447fc793c1bb8abfdc57b48ede19a8520b4f0fbd8ac5049c1a6"
    sha256 cellar: :any,                 monterey:       "9e999683403d69f710da052fca0017467b22aa8742bf71a8fc4c45a6bf9f5ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cd5982a74d6a6a45cf4cdeb3db1647a92fe04967a177465cc4fbdaa5b17da31"
  end

  depends_on "libcython" => :build
  depends_on "meson" => :build
  depends_on "meson-python" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pythran" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "python@3.12"
  depends_on "xsimd"

  cxxstdlib_check :skip

  fails_with gcc: "5"

  def python3
    "python3.12"
  end

  def install
    openblas = Formula["openblas"]
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = openblas.opt_lib/shared_library("libopenblas")

    config = <<~EOS
      [DEFAULT]
      library_dirs = #{HOMEBREW_PREFIX}/lib
      include_dirs = #{HOMEBREW_PREFIX}/include
      [openblas]
      libraries = openblas
      library_dirs = #{openblas.opt_lib}
      include_dirs = #{openblas.opt_include}
    EOS

    Pathname("site.cfg").write config

    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PATH", Formula["libcython"].opt_libexec/"bin"
    ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", Formula["pythran"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/site_packages
    ENV.prepend_create_path "PYTHONPATH", site_packages

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/scipy/**/*.pyc"]
  end

  test do
    (testpath/"test.py").write <<~EOS
      from scipy import special
      print(special.exp10(3))
    EOS
    assert_equal "1000.0", shell_output("#{python3} test.py").chomp
  end
end