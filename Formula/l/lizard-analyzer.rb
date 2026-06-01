class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "https://github.com/terryyin/lizard"
  url "https://files.pythonhosted.org/packages/03/6f/11abc1b580312fd50e0f592659ceeec8911e59a5d4fc127d2509979daf51/lizard-1.22.2.tar.gz"
  sha256 "39f6a44fb04b8d5edb9c4b95194fd3f8a7d29b2ec4ef30c6774a68f3561bd362"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fca471436191bc804490040f8e38a1def3085a6b11c80861d9db17ee4d8ec85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "346d212bdd1f3ed423ee8c195ea7983552ed550db18b2134f65d10c740af58c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ab89843fb215652afadc467f9ee2863741e5ba0e596513c49949ba36ca7b29b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bab881807c4c16db0292ec9c608b2c827a7794c61519bdfd5970d5f1c35b4345"
    sha256 cellar: :any,                 arm64_linux:   "bcde872a9d3e9e2322c7e25776d6e767251dd50691f3b62079df3d218eca22ac"
    sha256 cellar: :any,                 x86_64_linux:  "e5fb1a165de8c7a6721cdf821743102417a71686860cdbc4b8cdab56f741a472"
  end

  depends_on "python@3.14"

  conflicts_with "lizard", because: "both install `lizard` binaries"

  pypi_packages extra_packages: "jinja2"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.swift").write <<~SWIFT
      let base = 2
      let exponent_inner = 3
      let exponent_outer = 4
      var answer = 1

      for _ in 1...exponent_outer {
        for _ in 1...exponent_inner {
          answer *= base
        }
      }
    SWIFT

    output = shell_output("#{bin}/lizard --languages swift #{testpath}/test.swift")
    assert_match "1 file analyzed.", output
    html_output = shell_output("#{bin}/lizard --html --languages swift #{testpath}/test.swift")
    assert_match "<!DOCTYPE HTML PUBLIC", html_output
  end
end