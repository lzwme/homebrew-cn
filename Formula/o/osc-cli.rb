class OscCli < Formula
  include Language::Python::Virtualenv

  desc "Official Outscale CLI providing connectors to Outscale API"
  homepage "https:github.comoutscaleosc-cli"
  url "https:files.pythonhosted.orgpackages02cdf1b796f5e7a301f6a3c0b910be07188cbfd329d2758e036d24ef26b4ee96osc-sdk-1.11.0.tar.gz"
  sha256 "d3b71b326b0698da1b9a503cd511a992fe578375fd01b30bdec0d63d8328af66"
  license "BSD-3-Clause"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bddb25f9c950e14b4d36720e2d7b02fbdedc3abf3c4e90340854531112709ebc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a03f07487ddf29d015d32032b5491b735bde79051ed235e7abc72d76b10ba681"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a897fc9298436460cd5bc0424fcabc725bc60b21e24e45680db4d29f90c0205b"
    sha256 cellar: :any_skip_relocation, sonoma:         "56bc0acb572f109f04cf6e1ade8501a800520657a115e7fbb74fd2271d9f0ada"
    sha256 cellar: :any_skip_relocation, ventura:        "3db342c285653ea0b425c1f81634f952fe6fe61511a6708216b0668d0906c5e0"
    sha256 cellar: :any_skip_relocation, monterey:       "ce047e958fbe99ec9f12bae2ca8d696f0226b6b557f3d724de2a80a8d8f4b3ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "644dc2376972c59ad1c29dd559095237d3fd51c901dff58260a5beb70103cd5f"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "fire" do
    url "https:files.pythonhosted.orgpackages94ed3b9a10605163f48517931083aee8364d4d6d3bb1aa9b75eb0a4a5e9fbfc1fire-0.5.0.tar.gz"
    sha256 "a6b0d49e98c8963910021f92bba66f65ab440da2982b78eb1bbf95a0a34aacc6"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc93d74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fadsetuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackages1056d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764termcolor-2.4.0.tar.gz"
    sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackages0c1deb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "xmltodict" do
    url "https:files.pythonhosted.orgpackages390d40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7fxmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
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
    (testpath".oscconfig.json").write <<~EOS
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
    EOS

    str = shell_output("#{bin}osc-cli api ReadVms 2>&1 >devnull", 1)
    match = "raise OscApiException(http_response)"
    assert_match match, str
  end
end