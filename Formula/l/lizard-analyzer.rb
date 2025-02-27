class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "https:github.comterryyinlizard"
  url "https:files.pythonhosted.orgpackages411104a81bc89e9046b570ae0cab6928769b3fd1d6634e36b4012950e3825acflizard-1.17.20.tar.gz"
  sha256 "8c2e6fb07779fac72e510ce70d8369c375e7e7d3e04013a7ebe7b63d128591ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af4a3f8e0d34ca55319bb311bde405620a9d8926209879d03462fffa776cd543"
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