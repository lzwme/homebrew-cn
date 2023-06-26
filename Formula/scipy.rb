class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/fa/d0/724c8204f87b6f807e3e67de32b8b4922d579154a448ce94e89129064bf1/scipy-1.11.0.tar.gz"
  sha256 "f9b0248cb9d08eead44cde47cbf6339f1e9aa0dfde28f5fb27950743e317bd5d"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "607028416cf34beb6d199f491e22c558742bbc68c79cdadf32a43a34bcb3a88c"
    sha256 cellar: :any,                 arm64_monterey: "a9593372acb527f748bc6ab6ba5bd49e0d00deb75fe79e44f55d16db155d9979"
    sha256 cellar: :any,                 arm64_big_sur:  "926d74b880e82cabaced4b5e9f3d4e1542b796d9f26907e120b2a3d40c9d3026"
    sha256 cellar: :any,                 ventura:        "5093ce2259b25a22589923eb43759872ff2b7a055c040b3b9017a418832df6b7"
    sha256 cellar: :any,                 monterey:       "7fd9ce95790b991bb46e26f5a3f868dc8c3843f6a7c318a7fa6623f31d462546"
    sha256 cellar: :any,                 big_sur:        "c3602aabcc9ea294442b51bee50ea3b02beeb5cef7984ef73fecafd35b6ba57e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61067e69fc825196afe769bc28620a81ae5d0a4c9ef86165894fde77848d7631"
  end

  depends_on "libcython" => :build
  depends_on "pythran" => :build
  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "python@3.11"

  cxxstdlib_check :skip

  fails_with gcc: "5"

  def python3
    "python3.11"
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
    ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", Formula["pythran"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/site_packages
    ENV.prepend_create_path "PYTHONPATH", site_packages

    system python3, "setup.py", "build", "--fcompiler=gfortran", "--parallel=#{ENV.make_jobs}"
    system python3, *Language::Python.setup_install_args(prefix, python3)
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