class Ggshield < Formula
  include Language::Python::Virtualenv

  desc "Scanner for secrets and sensitive data in code"
  homepage "https:www.gitguardian.com"
  url "https:files.pythonhosted.orgpackages30143fddab1e72546c6aba3d6044c871d06fe2a0081a277389c08348ae21a74eggshield-1.32.1.tar.gz"
  sha256 "baa8f47ee0b1ff0c6038bc7681fc11380a093eb6939422d9db699345f604159e"
  license "MIT"
  head "https:github.comGitGuardianggshield.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8b7400d487cfc3f306f825b2484b098b083aebc5fa5ad2b5b5b3dafee01b507b"
    sha256 cellar: :any,                 arm64_sonoma:  "c841eec9dede6ca429406a371df79b6efc979592651a76e8e8fb9d4b00f11b8c"
    sha256 cellar: :any,                 arm64_ventura: "f1a2eb26ed5e42b869e4a29291324491bbd3a7462bf25596facc0819b3d08059"
    sha256 cellar: :any,                 sonoma:        "defe6fe2fdd0a22dda5ea6117c72573cd83c54061cf0077c1ebc28cd57811574"
    sha256 cellar: :any,                 ventura:       "898c8eeac3d9a35d3421ff51333783b22cfc4932d4ee0e5ce2a52f5ec46bbb7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84cbc563658ba39caba013f99fc391856c33ce69dc564c8ff0fdb37aa6fc7259"
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
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
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
    url "https:files.pythonhosted.orgpackages25b8599e73a3e2ee7466f70ddb39b7ccce04aa3a4b59140755378dd2a01031e2pygitguardian-1.17.0.tar.gz"
    sha256 "17ef91e7fe954f7b8d91f39c0097ba49b07e77b5ee9d0596adad256a9d4ab71e"
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
    url "https:files.pythonhosted.orgpackages27b8f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74bsetuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
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
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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