class Ggshield < Formula
  include Language::Python::Virtualenv

  desc "Scanner for secrets and sensitive data in code"
  homepage "https:www.gitguardian.com"
  url "https:files.pythonhosted.orgpackagesda859cf7b609e64c68edec72bad19e581354d9715d3dbf58a23a76b84a3ba0b4ggshield-1.40.0.tar.gz"
  sha256 "7ad3ac8ffef6b488a59363539e36e67e60fea58a221e41a08c871b63be956368"
  license "MIT"
  revision 1
  head "https:github.comGitGuardianggshield.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "80c1a5f6d96ee2172da225703c00a1b09aaed0139a3e28c650c68940706c2c13"
    sha256 cellar: :any,                 arm64_sonoma:  "c0eaa8e123144e3f5ca879db61ce50e95a69815fb1d822c8d7b55d22678a4fc4"
    sha256 cellar: :any,                 arm64_ventura: "e91013e7f74c03275a2b43cfcdaa966bf738c873a0e611cdc7a973ededdd61ce"
    sha256 cellar: :any,                 sonoma:        "92373616edd891dc932a93e80e438ad323c1e4694a3ef2b838ccd424eb63f72f"
    sha256 cellar: :any,                 ventura:       "ae15f21fdcac02d574f4f0c0bf8b31cc81960d76bcea59f8bcdc1fc591540bb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d08536dc5430db36285f933dfcf0ead729db744f2626f6ffb6c7da130c99a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88884bf4828497b2aacef144a770c9f9b62273fcc51cf960c28e53e6d7367f00"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesffd78d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
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
    url "https:files.pythonhosted.orgpackagesa26e371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628bmypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages1139702094fc1434a4408783b071665d9f5d8a1d0ba4dddf9dadf3d50e6eb762platformdirs-3.0.0.tar.gz"
    sha256 "8a1228abb1ef82d788f74139988b137e78692984ec7b08eaa6c65f1723af28f9"
  end

  resource "pygitguardian" do
    url "https:files.pythonhosted.orgpackages2455d55df088734cbfc80bb48608b2fbe3840171396c249e0da8bf93229ebf49pygitguardian-1.22.0.tar.gz"
    sha256 "d3e7214e16f06f2ba7c5ca1bc809dc1e1e4dbc9199e09f1c1b2947174d8b043b"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
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
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesbb2dc902484141330ded63c6c40d66a9725f8da5e818770f67241cf429eef825rich-12.5.1.tar.gz"
    sha256 "63a5c5ce3673d3d5fbbf23cd87e11ab84b6b451436f1b7f19ec54b6bc36ed7ca"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages185d3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fcasetuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "truststore" do
    url "https:files.pythonhosted.orgpackages0fa7b7a43228762966a13598a404f3dfb4803ea29a906f449d8b0e73ed0bcd30truststore-0.10.1.tar.gz"
    sha256 "eda021616b59021812e800fa0a071e51b266721bef3ce092db8a699e21c63539"
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

    generate_completions_from_executable(bin"ggshield", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ggshield --version")

    output = shell_output("#{bin}ggshield api-status 2>&1", 3)
    assert_match "Error: A GitGuardian API key is needed to use ggshield.", output
  end
end