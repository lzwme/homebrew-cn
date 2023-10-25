class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/60/a0/2a2bfbbab1d9bd4e1a24e3604c30b5d6f84219238f3c98f06191faf5d019/solc-select-1.0.4.tar.gz"
  sha256 "db7b9de009af6de3a5416b80bbe5b6d636bf314703c016319b8c1231e248a6c7"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07b826d0c1537cf1093a2e078fa3cff317e4b925cfb010c5c837a42f70af1cbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de60f7407a43524e866b85cc9fa23486ffa72df776dc7a0d7fc859b8834876b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9447b07126201a3e2cda1c17f1ae6b9302202fefb9480819332e52f934a6ccc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab579c6c9455faa2b3bb35f11f5648840018848b7c4e4bdeb248a41c39d8da2b"
    sha256 cellar: :any_skip_relocation, ventura:        "27cc8d84e1451e7a631ff3d29a8e84b1975f136f49dd4dd7da9f578a7e39bb55"
    sha256 cellar: :any_skip_relocation, monterey:       "41d0902be82ea2529d3a86cd169d01447b10a071b8a1821d5bf6c433cf7acd64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "642069ff0cd7f6c5a658e1f43ed279d77ae395faa2f7511548da23e2c1533e99"
  end

  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/05/0e7547c445bbbc96c538d870e6c5c5a69a9fa5df0a9df3e27cb126527196/pycryptodome-3.18.0.tar.gz"
    sha256 "c9adee653fc882d98956e33ca2c1fb582e23a8af7ac82fee75bd6113c55a0413"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"solc-select", "install", "0.5.7"
    system bin/"solc-select", "install", "0.8.0"
    system bin/"solc-select", "use", "0.5.7"

    assert_match(/0\.5\.7.*current/, shell_output("#{bin}/solc-select versions"))

    # running solc itself requires an Intel system or Rosetta
    return if Hardware::CPU.arm?

    assert_match("0.5.7", shell_output("#{bin}/solc --version"))
    with_env(SOLC_VERSION: "0.8.0") do
      assert_match("0.8.0", shell_output("#{bin}/solc --version"))
    end
  end
end