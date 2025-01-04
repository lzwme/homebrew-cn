class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https:www.scipy.org"
  url "https:files.pythonhosted.orgpackagesd97b2b8ac283cf32465ed08bc20a83d559fe7b174a484781702ba8accea001d6scipy-1.15.0.tar.gz"
  sha256 "300742e2cc94e36a2880ebe464a1c8b4352a7b0f3e36ec3d2ac006cdbe0219ac"
  license "BSD-3-Clause"
  head "https:github.comscipyscipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "51d99f5fe4ea1f86082892e70fbce5cd19ca9f8b7dd94c8807b5d30b5a664796"
    sha256 cellar: :any,                 arm64_sonoma:  "a07807db407ed6b5b1e656005443e921257249a322035bf07f881e78ca2c3c72"
    sha256 cellar: :any,                 arm64_ventura: "0a21e8fa8322d501545d7b87f4a8f62abdaad1dda8208dfea614d13ace28bfa5"
    sha256 cellar: :any,                 sonoma:        "7be516fc1bcd44bcd470841c723c946a60e3dfe1b8a83867c9d982583d05f30d"
    sha256 cellar: :any,                 ventura:       "73ad4e670effc4712ab06c85e3c258f24710e84a851dab0afba5b3cf04f18b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96542b1905d985ffb426243b407d6e1bc82cab84d6ec72c764f6d91c9c7d2e00"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "xsimd"

  on_linux do
    depends_on "patchelf" => :build
  end

  cxxstdlib_check :skip

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec"binpython" }
  end

  def install
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  def post_install
    HOMEBREW_PREFIX.glob("libpython*.*site-packagesscipy***.pyc").map(&:unlink)
  end

  test do
    (testpath"test.py").write <<~PYTHON
      from scipy import special
      print(special.exp10(3))
    PYTHON
    pythons.each do |python3|
      assert_equal "1000.0", shell_output("#{python3} test.py").chomp
    end
  end
end