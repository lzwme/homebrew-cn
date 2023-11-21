class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/6e/1f/91144ba78dccea567a6466262922786ffc97be1e9b06ed9574ef0edc11e1/scipy-1.11.4.tar.gz"
  sha256 "90a2b78e7f5733b9de748f589f09225013685f9b218275257f8a8168ededaeaa"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "14ca1141efff56a2a0cf908d962a3b6598183109850cd058752551084e1871c7"
    sha256 cellar: :any,                 arm64_ventura:  "7450fdcc89db83945b2474b3712dd3281be211c27d39ef44315d61db248eb9f3"
    sha256 cellar: :any,                 arm64_monterey: "6488fdf4ab00ff55fabbc70f6deb2dfd41fd5946d6fa33be7a646cad5014375e"
    sha256 cellar: :any,                 sonoma:         "c17511eb6f15a5e081c0fdc02536770db4f9863b95d8b3f36c8ba4c88d1544f6"
    sha256 cellar: :any,                 ventura:        "0ea4f911e75230b063febacc732ef65c9f136be208df055770093df693f78bb5"
    sha256 cellar: :any,                 monterey:       "7dc8355c6a8dec426c6a1a17f9d171023457af671b6192085bcfca96eaec90bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c74212b12edfde9e6b1d18db99e3291704bdc6f958f1dd10448029695c98b81"
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