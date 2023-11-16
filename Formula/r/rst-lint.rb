class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://files.pythonhosted.org/packages/48/9c/6d8035cafa2d2d314f34e6cd9313a299de095b26e96f1c7312878f988eec/restructuredtext_lint-1.4.0.tar.gz"
  sha256 "1b235c0c922341ab6c530390892eb9e92f90b9b75046063e047cacfb0f050c45"
  license "Unlicense"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6daabe5f77da7cfa5d97729c57c1e5e5075bc17e5e876cf487260db84b9a787"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4541426741a2bd4ed685fe19a9ede90749c46fc53409994e087a90c2bf4096bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9dca620dc6d95839222daa0899871c76361c477147f9a1e4f8ff68e51b54090"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a44fbaaa0ad9a209729f3ddf45e6c0632263e53a76bbfb9cfc5b687d6381086"
    sha256 cellar: :any_skip_relocation, ventura:        "2c9f9831c0fc8621b5b93dca532758f0cfd46866d386f66f759384403ae413fa"
    sha256 cellar: :any_skip_relocation, monterey:       "f0ebcbe939c0f88cd09d569f7b33544948e191cc389ef8c836f3ebbff2a1442d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15bfc2601533522d36ddfcc91f9db2b93a329179b71ed341032543ce51079329"
  end

  depends_on "docutils"
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    # test invocation on a file with no issues
    (testpath/"pass.rst").write <<~EOS
      Hello World
      ===========
    EOS
    assert_equal "", shell_output("#{bin}/rst-lint pass.rst")

    # test invocation on a file with a whitespace style issue
    (testpath/"fail.rst").write <<~EOS
      Hello World
      ==========
    EOS
    output = shell_output("#{bin}/rst-lint fail.rst", 2)
    assert_match "WARNING fail.rst:2 Title underline too short.", output
  end
end