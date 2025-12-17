class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/62/89/51e614fdbf26f47268c18f8a3b6cf1cb67c9a8b48b7b7231c948cae97814/solc_select-1.2.0.tar.gz"
  sha256 "ad0a7afcae05061ce5e7632950b1fa0193ba9eaf05e4956f86effee024c6fb07"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcd3dba43e5b829cb1678cdea5dfad0f88b1bf5e88639dac06bae7a03d0cf828"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "976171dbf9ae245a10d75162c2da94b6154512678d6b986c7b65e04c0f0d54e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edd45e039237ea555c60ae48a49fec8018f4a2fbbfc2b4fce15bd709f50a4182"
    sha256 cellar: :any_skip_relocation, tahoe:         "66ef9fd24b05dcb88eebd2ca9bdc89f73afd8dcac16f2914f01b91bc60d314fe"
    sha256 cellar: :any_skip_relocation, sequoia:       "478eaf22516bbbd67fd7856ceb9d2375173fd15d67a06ffcfd7a99933e4eb722"
    sha256 cellar: :any_skip_relocation, sonoma:        "f52067fa818f5d5dcaaf6dba9e5fc81805f4327dded6aa437fa13d1e4976748c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63faa76f11a00f5e79ebc3abaf359e41b5e0bcd343acfe7462b9a92e87585389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad4c7233516e78d57e7d9f7518abd4f5648bfbe95dd89b4ef44b26162dfdc314"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  conflicts_with "solidity", because: "both install `solc` binaries"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1e/24/a2a2ed9addd907787d7aa0355ba36a6cadf1768b934c652ea78acbd59dcd/urllib3-2.6.2.tar.gz"
    sha256 "016f9c98bb7e98085cb2b4b17b87d2c702975664e4f060c6532e64d1c1a5e797"
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