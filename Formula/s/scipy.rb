class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/f5/4a/b927028464795439faec8eaf0b03b011005c487bb2d07409f28bf30879c4/scipy-1.16.1.tar.gz"
  sha256 "44c76f9e8b6e8e488a586190ab38016e4ed2f8a038af7cd3defa903c0a2238b3"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "255c4691820a6b2034f7ee246dcaee281324254a985f8f1bbfbedd8323380cc2"
    sha256 cellar: :any,                 arm64_sequoia: "cfaca463972c3ea463d3eb63c61c73eae80ede960ecaa25a365eb5b31b4b3935"
    sha256 cellar: :any,                 arm64_sonoma:  "753153cd23a5aa2ea3f507dd5a19d32547d9f6c5729b3c2ecf69e8992aa7102f"
    sha256 cellar: :any,                 arm64_ventura: "2dece15a1d2c37ac8df48236819bc941cbdbd69a88591a63780566f6e7b75074"
    sha256 cellar: :any,                 sonoma:        "d59ccd9807a3351772a5c79c88ee1be5ba5e72f2764fd94a8ea2148c108adc27"
    sha256 cellar: :any,                 ventura:       "41c92055af315c111135f9485cc37c911fe70e12c161e8e8a89296b40fd177f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61bd2093fa0aa5c578476eee73f756d5e7b18b11730e5b2e268617d438a12d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93531a11bc67bf09d7323a8cba0868d9ef4e516e04cd04da09235d1f3d7741bd"
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

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  def post_install
    HOMEBREW_PREFIX.glob("lib/python*.*/site-packages/scipy/**/*.pyc").map(&:unlink)
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from scipy import special
      print(special.exp10(3))
    PYTHON
    pythons.each do |python3|
      assert_equal "1000.0", shell_output("#{python3} test.py").chomp
    end
  end
end