class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https:www.scipy.org"
  url "https:files.pythonhosted.orgpackages4ee50230da034a2e1b1feb32621d7cd57c59484091d6dccc9e6b855b0d309fc9scipy-1.14.0.tar.gz"
  sha256 "b5923f48cb840380f9854339176ef21763118a7300a88203ccd0bdd26e58527b"
  license "BSD-3-Clause"
  head "https:github.comscipyscipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fe758682f00ede121166bc636f573842f1eada3dcdab6b8705aca1b1a02bb612"
    sha256 cellar: :any,                 arm64_ventura:  "382d5a07216ddba1c101de3a3dc878f946fcc1ed3d1577fd4f84df8d32902297"
    sha256 cellar: :any,                 arm64_monterey: "628df76fa2f37e3931dba6d919f7ee96ae834b1a439cb61e19830c04a77414cb"
    sha256 cellar: :any,                 sonoma:         "b5282e01ff6b2527e732bed3eb63da329a7b7ce3e1d062222abdeb23f62194b2"
    sha256 cellar: :any,                 ventura:        "c4caa67d194b2c1b963b8cd99a5bcb68fe5a1f648550a434577a07c0c654e6bf"
    sha256 cellar: :any,                 monterey:       "aacff7826c8eefff3da562e3486f03ac7e9234e1512ababf3241026047ee235f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae10a6a86bb432a478065204035ad24ee913db75b6a84d4cbdfe934a5dadb0ab"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.12"
  depends_on "xsimd"

  on_linux do
    depends_on "patchelf" => :build
  end

  cxxstdlib_check :skip

  fails_with gcc: "5"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
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
    assert_equal "1000.0", shell_output("#{python3} test.py").chomp
  end
end