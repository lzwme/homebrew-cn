class OscCli < Formula
  include Language::Python::Virtualenv

  desc "Official Outscale CLI providing connectors to Outscale API"
  homepage "https:github.comoutscaleosc-cli"
  url "https:files.pythonhosted.orgpackages02cdf1b796f5e7a301f6a3c0b910be07188cbfd329d2758e036d24ef26b4ee96osc-sdk-1.11.0.tar.gz"
  sha256 "d3b71b326b0698da1b9a503cd511a992fe578375fd01b30bdec0d63d8328af66"
  license "BSD-3-Clause"
  revision 8

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbdb9054c1453179f2d263b5982582ba142a6656a822bc085241b02f3fd1265c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbdb9054c1453179f2d263b5982582ba142a6656a822bc085241b02f3fd1265c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbdb9054c1453179f2d263b5982582ba142a6656a822bc085241b02f3fd1265c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1560352637ab7bd7d48dfd9efabdb2fa508adc081d707416a48b4c2096fcb54f"
    sha256 cellar: :any_skip_relocation, ventura:       "1560352637ab7bd7d48dfd9efabdb2fa508adc081d707416a48b4c2096fcb54f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8caa74902e4f0660499891159a7fc666c224a312bee83ced94ac3b9379588e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8caa74902e4f0660499891159a7fc666c224a312bee83ced94ac3b9379588e18"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "fire" do
    url "https:files.pythonhosted.orgpackages6bb682c7e601d6d3c3278c40b7bd35e17e82aa227f050aa9f66cb7b7fce29471fire-0.7.0.tar.gz"
    sha256 "961550f07936eaf65ad1dc8360f2b2bf8408fad46abbfa4d2a3794f8d2a95cdf"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages185d3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fcasetuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackagesca6c3d75c196ac07ac8749600b60b03f4f6094d54e132c4d94ebac6ee0e0add0termcolor-3.1.0.tar.gz"
    sha256 "6a6dd7fbee581909eeec6a756cff1d7f7c376063b14e4a298dc4980309e55970"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "xmltodict" do
    url "https:files.pythonhosted.orgpackages500551dcca9a9bf5e1bce52582683ce50980bcadbc4fa5143b9f2b19ab99958fxmltodict-0.14.2.tar.gz"
    sha256 "201e7c28bb210e374999d1dde6382923ab0ed1a8a5faeece48ab525b7810a553"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # we test the help which is printed in stderr
    str = shell_output("#{bin}osc-cli -- --help 2>&1 >devnull")
    assert_match "osc-cli SERVICE CALL <flags>", str
    str = shell_output("#{bin}osc-cli api ReadVms 2>&1 >devnull", 1)
    assert_match "Missing Access Key for authentication", str

    mkdir testpath".osc"
    (testpath".oscconfig.json").write <<~JSON
      {
        "default": {
          "access_key": "F4K4T706S9XKGEXAMPLE",
          "secret_key": "E4XJE8EJ98ZEJ18E4J9ZE84J19Q8E1J9S87ZEXAMPLE",
          "host": "outscale.com",
          "https": true,
          "method": "POST",
          "region_name": "eu-west-2"
        }
      }
    JSON

    str = shell_output("#{bin}osc-cli api ReadVms 2>&1 >devnull", 1)
    match = "raise OscApiException(http_response)"
    assert_match match, str
  end
end