class Ggshield < Formula
  include Language::Python::Virtualenv

  desc "Scanner for secrets and sensitive data in code"
  homepage "https:www.gitguardian.com"
  url "https:files.pythonhosted.orgpackagesd696b965c7bdb074420bb8037359c9fb69e609e4ab5c183808bf27594bb66d6cggshield-1.22.0.tar.gz"
  sha256 "a8135f686bf454a99673f21ed8a75fb6119a938e148f3ddd01f423d5face6de8"
  license "MIT"
  head "https:github.comGitGuardianggshield.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd6b7dfb0ec27ad339e4bca87e1a470d8ae019cc9b77e4d46920ad03b5b9f6e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2938fa4be81b1ae63aeb2d04dee413b1a3e0a2a8e739b2eed9473557b79d84da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cbc6ebcc1a656c6cddc521471d0c80e6b367240ac8624206c007e953e9e678c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9de84ea63255c56b52fadac3496bcc470c1a848d8088e37ca1fa9188691ed1a8"
    sha256 cellar: :any_skip_relocation, ventura:        "9cbb08718867673b09fbe7c8d2b9ca7e6c71e4edeb2bce68f38c98f039b5a312"
    sha256 cellar: :any_skip_relocation, monterey:       "1c485b538dca687fa05a4c95afd52187a98c7b6c3ec84ef17d33ce27917fa742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d5e779b2f7d50b864b789aa94a9e5b94f058458696d3438e129a0944f0b5fbe"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesffd78d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "commonmark" do
    url "https:files.pythonhosted.orgpackages6048a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "marshmallow" do
    url "https:files.pythonhosted.orgpackagesb8b9b1da16dac90ed19806ea466636ae387957eec8cd429ac3b763e21b99a77dmarshmallow-3.18.0.tar.gz"
    sha256 "6804c16114f7fce1f5b4dadc31f4674af23317fcc7f075da21e35c1a35d781f7"
  end

  resource "marshmallow-dataclass" do
    url "https:files.pythonhosted.orgpackages20f21af94d8e8432ddd80e30983b3c7fdeb4cf7c9b0790d6d4855c4343dbecdemarshmallow_dataclass-8.5.14.tar.gz"
    sha256 "233c414dd24a6d512bcdb6fb840076bf7a29b7daaaea40634f155a5933377d2e"
  end

  resource "mypy-extensions" do
    url "https:files.pythonhosted.orgpackages98a41ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3fmypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "pygitguardian" do
    url "https:files.pythonhosted.orgpackagesdb697fa8a2c9745806c42d704feb23413569c9c0eb6b9bc325d1967d3eec1704pygitguardian-1.11.0.tar.gz"
    sha256 "6f1b9c1e9628032ef620d7c8440ee5a3cfd7f00f79bce02d9c609dcac6abd776"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackages7565db64904a7f23e12dbf0565b53de01db04d848a497c6c9b87e102f74c9304PyJWT-2.6.0.tar.gz"
    sha256 "69285c7e31fc44f68a1feb309e948e0df53259d579295e6cfe2b1792329f05fd"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackagesf5d7d548e0d5a68b328a8d69af833a861be415a17cb15ce3d8f0cd850073d2e1python-dotenv-0.21.1.tar.gz"
    sha256 "1c93de8f636cde3ce377292818d0e440b6e45a82f215c3744979151fa8151c49"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesbb2dc902484141330ded63c6c40d66a9725f8da5e818770f67241cf429eef825rich-12.5.1.tar.gz"
    sha256 "63a5c5ce3673d3d5fbbf23cd87e11ab84b6b451436f1b7f19ec54b6bc36ed7ca"
  end

  resource "typing-inspect" do
    url "https:files.pythonhosted.orgpackagesdc741789779d91f1961fa9438e9a8710cdae6bd138c80d7303996933d117264atyping_inspect-0.9.0.tar.gz"
    sha256 "b23fc42ff6f6ef6954e4852c1fb512cdd18dbea03134f91f856a95ccc9461f78"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ggshield --version")

    output = shell_output("#{bin}ggshield api-status 2>&1", 3)
    assert_match "Error: A GitGuardian API key is needed to use ggshield.", output
  end
end