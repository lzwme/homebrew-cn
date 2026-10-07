class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "https://github.com/terryyin/lizard"
  url "https://files.pythonhosted.org/packages/05/87/0352f911886e8b10b06b36dca674b9da91a25112bd08253b84346a1815e5/lizard-1.24.1.tar.gz"
  sha256 "c022cf1aac8170994b175e2a700f0535088f66da7e6bdf6c59fbd3b716cd10ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "045cc6c308d4b953e966cddd7d0a9949f321959282ec366fdd9bb899cb9a0f0b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "79171dce4084e26b55985884b8358eca39462a9aa7e701236a2c1c9576804c8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6a9e0edd7f5bd4cb62a8bde1bf38ce1a874bec00e916e9f80506b75ec82a01e"
    sha256 cellar: :any,                 arm64_linux:       "1ce391a094c9462b0fcfa5bf576b46e7d784b9c9f51137c2a56d4ded1a573070"
    sha256 cellar: :any,                 x86_64_linux:      "1a20017c77a0c2b74ee871fb13077e5f10b6b386e1dc8401a111c0a609243b91"
  end

  depends_on "python@3.14"

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