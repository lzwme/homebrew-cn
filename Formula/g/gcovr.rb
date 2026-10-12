class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/07/37/b4a87dff166dc0a5002e9d03fcb6ca8eeff048247b011b67f047e31122c9/gcovr-8.6.tar.gz"
  sha256 "b2e7042abca9321cadbab8a06eb34d19f801b831557b28cdc30a029313de8b9e"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/gcovr/gcovr.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32126a702c47ea147ab8845c17996c2d13f9b4f9d28339afdfed9d4c1cbaf6ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "25aa5effb9e3b6519dbfc474b6e9c27d3299c9282b37153ac03816354e672d6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8707f523f88369bdd860ceeb9dee4d37139f187e8e55c8462b7b779923ac0812"
    sha256 cellar: :any,                 arm64_linux:       "d8049dce31f55e436aac95d4244fb1fd055e826b5ca4f3cc47f652037cd7e0b3"
    sha256 cellar: :any,                 x86_64_linux:      "53edf1f3a9177a57227bae6fc720385be544500af323211ba5bc43dea1c0b45c"
  end

  depends_on "python@3.15"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/8c/55/ba79756cb90c8d69d599d57785398ac87bba7b19c80e87f4e8a562197c93/colorlog-6.12.0.tar.gz"
    sha256 "2a7924c1dadf18b22a0eb8b06d1c7b01d5341707ec1641eb6fcc4fde0c3e8e5f"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.c").write <<~C
      int main() {
        return 0;
      }
    C

    # gcov must match the c compiler version, which is gcc-12 on linux
    ENV["GCOV"] = ENV.cc.sub("gcc", "gcov") if OS.linux?
    system ENV.cc, "--coverage", "-g", "-O0", "-o", "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}/gcovr")
  end
end