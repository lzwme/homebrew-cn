class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "https://github.com/terryyin/lizard"
  url "https://files.pythonhosted.org/packages/f8/85/323734da1a70492b432a04bd2665a012eade1378c2ea913c960cfe138b1d/lizard-1.24.2.tar.gz"
  sha256 "84ac9c687bf38e9dd7a7fc179ab4113858bd0fa125cef328812f88be5cd13d30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bef1728bcb02e20637e4ca627404d7d97313f5d1b1e7be08a2bfcbf99ed6544d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d45936add835bac194df4a8530d1624f16a55c80d423ba3d620f66784bd13da1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "edfbf062b133a6d40ea7ce62d75e7cad117a42e85381e6789a036d75ed807ae2"
    sha256 cellar: :any,                 arm64_linux:       "fbeb8c9a7c9fa336536504a6873b934694f8c39c4d5b3c31a22131f1eccbf1d2"
    sha256 cellar: :any,                 x86_64_linux:      "159f04e25b3faf2e2f4377f52155722917b28d0b4b6b089013977a95daae4bcc"
  end

  depends_on "python@3.15"

  conflicts_with "lizard", because: "both install `lizard` binaries"

  pypi_packages extra_packages: "jinja2"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
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