class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "https:github.comterryyinlizard"
  url "https:files.pythonhosted.orgpackages3fc314260a583813cdb160eb715b30ae3013f4c107bca6464208b56cb2cce31clizard-1.17.29.tar.gz"
  sha256 "067eaa90366b7b3db8c3c2b4fb7af29fda8943ac6457d8207d5b9842c7e96b0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b0b1941a1e26373bbceb0e8b045e1c439ad24133099f7a9561949eb4851a1f8"
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