class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https:www.scipy.org"
  url "https:files.pythonhosted.orgpackages6e1f91144ba78dccea567a6466262922786ffc97be1e9b06ed9574ef0edc11e1scipy-1.11.4.tar.gz"
  sha256 "90a2b78e7f5733b9de748f589f09225013685f9b218275257f8a8168ededaeaa"
  license "BSD-3-Clause"
  head "https:github.comscipyscipy.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "4896cd0a9ce676799572f79955f8130730396d4ce7ee1906de29887bca2a926a"
    sha256 cellar: :any,                 arm64_ventura:  "0fbb27be6c587b2a93012f2481e9455fc9e948280de18bc409ee34dfe789ea5f"
    sha256 cellar: :any,                 arm64_monterey: "021dbd48d31691391dc450800ce5360dedc6ba2649b8f914b464d9a61126cea1"
    sha256 cellar: :any,                 sonoma:         "ea5ae340909ee300580379041849d1b2eeb0a00122fc124e9ac450ee15a05b73"
    sha256 cellar: :any,                 ventura:        "766729c0e24d756f4437ac87148effb330a6e19a528301cf3b1647983ffd6020"
    sha256 cellar: :any,                 monterey:       "923731834f661a57771abf52652a8ea8d38b36228ac04cc18d35d8617888431d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b16b58aad7cb25d2ef852d7e940bd28a2e01a1f1f9abcfdb98d53d32ab0855ee"
  end

  depends_on "libcython" => :build
  depends_on "meson" => :build
  depends_on "meson-python" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "pythran" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "xsimd"

  cxxstdlib_check :skip

  fails_with gcc: "5"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    ENV.prepend_path "PATH", Formula["libcython"].opt_libexec"bin"

    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      site_packages = Language::Python.site_packages(python_exe)
      ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexecsite_packages

      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https:github.comHomebrewhomebrew-pythonissues185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}libpython*.*site-packagesscipy***.pyc"]
  end

  test do
    (testpath"test.py").write <<~EOS
      from scipy import special
      print(special.exp10(3))
    EOS
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      assert_equal "1000.0", shell_output("#{python_exe} test.py").chomp
    end
  end
end