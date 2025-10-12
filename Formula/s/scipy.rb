class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/4c/3b/546a6f0bfe791bbb7f8d591613454d15097e53f906308ec6f7c1ce588e8e/scipy-1.16.2.tar.gz"
  sha256 "af029b153d243a80afb6eabe40b0a07f8e35c9adc269c019f364ad747f826a6b"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cfb4f09c94e41afaef4519e1430849a37439505268c975d2040ac3cebb932844"
    sha256 cellar: :any,                 arm64_sequoia: "fb2964767baeb4c5cbe9a4e7b712fe9445ffb400710bfc76fe97b456cbe74db3"
    sha256 cellar: :any,                 arm64_sonoma:  "f80ce1c1d61723fb2b1ab3c49c8d2d44c725dc9b3cfb12a3970a789d030ea43d"
    sha256 cellar: :any,                 sonoma:        "93a94d55deb948cf23414f77b4f971c033d3d362917356e28a6dcad1b8485909"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08e4658b184d8959ac2d5edd643171553816f7002f85a832d0f95f80cb9a8118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08ed52184eaac90f17f10c493ae8129f6655b1360437982345a91e94a1c79a5a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
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