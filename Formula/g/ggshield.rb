class Ggshield < Formula
  include Language::Python::Virtualenv

  desc "Scanner for secrets and sensitive data in code"
  homepage "https:www.gitguardian.com"
  url "https:files.pythonhosted.orgpackagesdf1f4fef6963ac9846a88a033a633e369a04d06ad3b77bfc7939afade16aadb9ggshield-1.31.0.tar.gz"
  sha256 "42d83d2b117e02c813740eee1a045803e742d19b5b893528881de793409f39b2"
  license "MIT"
  head "https:github.comGitGuardianggshield.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "32bf147224302ae0061099f2bc80e2919995f239678def27481a5ab6b008d837"
    sha256 cellar: :any,                 arm64_sonoma:   "8dbd4f1a2e1e31499fddba104a5565660a27763a40ced3c37872d3e65fbc6120"
    sha256 cellar: :any,                 arm64_ventura:  "f2b8130b7e2360bea9e6fa7712fc0092b0be5779587a44bccdefe3ad98dd5be4"
    sha256 cellar: :any,                 arm64_monterey: "06ba5e7ec6849e8a68bcf2d5924a2516bc388bd49a425ce9942bc083b8b2c23b"
    sha256 cellar: :any,                 sonoma:         "9f63b8bd61279051fd4f2a8a16ffbee9ceb60dcfe2d83f0acc027c4d000ff5d5"
    sha256 cellar: :any,                 ventura:        "183f6f776354775f662a52c2bdb9ad1e2122d2ec813b339990d152c249039e2b"
    sha256 cellar: :any,                 monterey:       "a2be6d92b8281fe3210a7062d182d2f16b9e5a9633729d7d4da397eb3bc2c516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d60042d7178978268756f5dd11195841ba49effb889e726feffcd9cf835e143"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesffd78d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "commonmark" do
    url "https:files.pythonhosted.orgpackages6048a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagese8ace349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72aidna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
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

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages1139702094fc1434a4408783b071665d9f5d8a1d0ba4dddf9dadf3d50e6eb762platformdirs-3.0.0.tar.gz"
    sha256 "8a1228abb1ef82d788f74139988b137e78692984ec7b08eaa6c65f1723af28f9"
  end

  resource "pygitguardian" do
    url "https:files.pythonhosted.orgpackages933d179b099ccd428338f94e12fcad76d61d5c77a23503c015c4c2b6bd9adc0apygitguardian-1.16.0.tar.gz"
    sha256 "91f7c5454fcf7d337946f53c35d035e4979224bf45eba85ed82f9d3939c904fd"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackages7565db64904a7f23e12dbf0565b53de01db04d848a497c6c9b87e102f74c9304PyJWT-2.6.0.tar.gz"
    sha256 "69285c7e31fc44f68a1feb309e948e0df53259d579295e6cfe2b1792329f05fd"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackagesf5d7d548e0d5a68b328a8d69af833a861be415a17cb15ce3d8f0cd850073d2e1python-dotenv-0.21.1.tar.gz"
    sha256 "1c93de8f636cde3ce377292818d0e440b6e45a82f215c3744979151fa8151c49"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesbb2dc902484141330ded63c6c40d66a9725f8da5e818770f67241cf429eef825rich-12.5.1.tar.gz"
    sha256 "63a5c5ce3673d3d5fbbf23cd87e11ab84b6b451436f1b7f19ec54b6bc36ed7ca"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages8d37f4d4ce9bc15e61edba3179f9b0f763fc6d439474d28511b11f0d95bab7a2setuptools-73.0.1.tar.gz"
    sha256 "d59a3e788ab7e012ab2c4baed1b376da6366883ee20d7a5fc426816e3d7b1193"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "typing-inspect" do
    url "https:files.pythonhosted.orgpackagesdc741789779d91f1961fa9438e9a8710cdae6bd138c80d7303996933d117264atyping_inspect-0.9.0.tar.gz"
    sha256 "b23fc42ff6f6ef6954e4852c1fb512cdd18dbea03134f91f856a95ccc9461f78"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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