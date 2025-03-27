class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "https:github.comterryyinlizard"
  url "https:files.pythonhosted.orgpackages8ceb0ae2ec5b7a9d6f5517a26d3329e5e9b4e5a383afa7e9386023b09c02971alizard-1.17.22.tar.gz"
  sha256 "fefd8f55f3f3dcde965576e24fc5bfb3e21d7ebd291181b79872f075ab152353"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec7f6919f4a77399842e7e8da686eee091a11ddabb123918ed316f149504b85d"
  end

  depends_on "python@3.13"

  conflicts_with "lizard", because: "both install `lizard` binaries"

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.swift").write <<~SWIFT
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

    assert_match "1 file analyzed.", shell_output("#{bin}lizard -l swift #{testpath}test.swift")
  end
end