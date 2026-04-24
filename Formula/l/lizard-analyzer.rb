class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "https://github.com/terryyin/lizard"
  url "https://files.pythonhosted.org/packages/d5/5e/8b4f17dcc5ea18562cc4b86d139700d7ac8e877c253dea0d9a4a905fe277/lizard-1.22.0.tar.gz"
  sha256 "a5f5ef82a9781a93cee163af0aa7eae588238d4827287deb51cae4af73a00b73"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f217a0ddab2a424818766f0f91673dc2a697ac71b830928e6586c82ee1f0b3ba"
  end

  depends_on "python@3.14"

  conflicts_with "lizard", because: "both install `lizard` binaries"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/fa/36/e27608899f9b8d4dff0617b2d9ab17ca5608956ca44461ac14ac48b44015/pathspec-1.0.4.tar.gz"
    sha256 "0210e2ae8a21a9137c0d470578cb0e595af87edaa6ebf12ff176f14a02e0e645"
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

    assert_match "1 file analyzed.", shell_output("#{bin}/lizard -l swift #{testpath}/test.swift")
  end
end