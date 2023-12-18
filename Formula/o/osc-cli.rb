class OscCli < Formula
  include Language::Python::Virtualenv

  desc "Official Outscale CLI providing connectors to Outscale API"
  homepage "https:github.comoutscaleosc-cli"
  url "https:files.pythonhosted.orgpackages02cdf1b796f5e7a301f6a3c0b910be07188cbfd329d2758e036d24ef26b4ee96osc-sdk-1.11.0.tar.gz"
  sha256 "d3b71b326b0698da1b9a503cd511a992fe578375fd01b30bdec0d63d8328af66"
  license "BSD-3-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "668ea8558974cc73bd548b28c7cf0fb9f1e2ce68520abfaf2e98eba144e743cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd06234015179d6a5dd23c9b7bafeea6bba00e35f8e14c67330675e060558557"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c07dce4a1486decbe9cf8507ec9a90830a0e7999debf36a7842662ee176b8d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6b3a69348a16c72e3eaaf2928b2fad6ada8db23a017b755eccac2e273546b85"
    sha256 cellar: :any_skip_relocation, ventura:        "8e048e653d6e25c49977b56dfc2305f999533c1a06e860de846e06e2d1b15c48"
    sha256 cellar: :any_skip_relocation, monterey:       "f650b6c13de419cd45eb83df9db96876b71aa97d431e24776e07640f3e3c3da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "160eff20273dd30bef005084c74a21213fff040a1b65f9ab93abfb1a42820247"
  end

  depends_on "python-certifi"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagescface89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackagesb885147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444ctermcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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