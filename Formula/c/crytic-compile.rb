class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/f4/cb/669ed02fbfe17091998f52a7e3326ac276409117ea10a2c36b2a852a22f9/crytic_compile-0.3.11.tar.gz"
  sha256 "d4e2253d5d81ec3a75deb3ab9fc2c2d2db56e835001cf07f3703911d74b56716"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "486cc8e7794a9222e8110159722a92c9f4feb916753d7c3c69e85eee947ed9d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04c323f1d8b9a41384386416cdc9164c1ddbb6bf323cb0ac010b4b2ac0f2df30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b39521fd9714f303bd81dea24b4227e4ec536bf99045d7251850d0fd2e09129a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c35f7550d2fe648f6fe75bf3c6a76272839a2d3a160fe1c2499109205e4494b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13ca2fdce4bc6fc05324580ba599e7081d75c0ca279ce5de8a312a5005817d62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "067040031ea1abe690c86a41a3618c4a647d8f64e08c02919a35e764f81deedd"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/d9/8e/8b4fdde28e42ffcd741a37f4ffa9fb59cd4fe01625b544dfcfd9ccb54f01/cbor2-5.8.0.tar.gz"
    sha256 "b19c35fcae9688ac01ef75bad5db27300c2537eb4ee00ed07e05d8456a0d4931"
  end

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

  resource "solc-select" do
    url "https://files.pythonhosted.org/packages/62/89/51e614fdbf26f47268c18f8a3b6cf1cb67c9a8b48b7b7231c948cae97814/solc_select-1.2.0.tar.gz"
    sha256 "ad0a7afcae05061ce5e7632950b1fa0193ba9eaf05e4956f86effee024c6fb07"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1e/24/a2a2ed9addd907787d7aa0355ba36a6cadf1768b934c652ea78acbd59dcd/urllib3-2.6.2.tar.gz"
    sha256 "016f9c98bb7e98085cb2b4b17b87d2c702975664e4f060c6532e64d1c1a5e797"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "testdata" do
      url "https://github.com/crytic/slither/raw/d0a4f5595d7177b3b7d4bd35e1384bf35ebc22d4/tests/ast-parsing/compile/variable-0.8.0.sol-0.8.15-compact.zip", using: :nounzip
      sha256 "2f165f629882d0250d03a56cb67a84e9741375349195915a04385b0666394478"
    end

    resource("testdata").stage do
      system bin/"crytic-compile", "variable-0.8.0.sol-0.8.15-compact.zip",
             "--export-format=solc", "--export-dir=#{testpath}/export"
    end

    assert_path_exists testpath/"export/combined_solc.json"
  end
end