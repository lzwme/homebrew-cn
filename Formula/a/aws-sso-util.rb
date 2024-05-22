class AwsSsoUtil < Formula
  include Language::Python::Virtualenv

  desc "Smooth out the rough edges of AWS SSO (temporarily, until AWS makes it better)"
  homepage "https:github.combenkehoeaws-sso-util"
  url "https:files.pythonhosted.orgpackages6e9390d3753ac7ea3148c41c43929cace11d8fc1331c629497ab24a91a6c3724aws_sso_util-4.32.0.tar.gz"
  sha256 "2649dcf3c594851a0c55ed6ebf2df70205d1debd6e58e263738430d4703890ec"
  license "Apache-2.0"
  revision 6
  head "https:github.combenkehoeaws-sso-util.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "183b8d56116ebf20fc1cde868a21722ef9ce7a40bbe16e151aee9166242e6d4c"
    sha256 cellar: :any,                 arm64_ventura:  "9d788f13ed8c7b9099b6c3c3a8eb639c74fb868a77dba4c5630373495c582144"
    sha256 cellar: :any,                 arm64_monterey: "e716b9f7ba9c2709692eda0bf4c2fed3bcde76e2bdba9ba6556289352df152b6"
    sha256 cellar: :any,                 sonoma:         "a94a1822a0cbfce232fa2e7d40fbe86fb912a14910b209e98d8b5915c77b6c72"
    sha256 cellar: :any,                 ventura:        "e02ab584717180357ba8b5d6dddc35a0313372e32dd5d69ebc9bf0e86ce20d22"
    sha256 cellar: :any,                 monterey:       "be6858058657c027555d31973f8ef642e2543010d03405909cca9b8de9eea2ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00bfb48426323bd428df0df9092fe6551bd3fb947e6e43865ed6726b58ef7121"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "aws-error-utils" do
    url "https:files.pythonhosted.orgpackages2afc2541892cafad6658e9ce5226e54088eff9692cbe4a32cd5a7dfec5846cbfaws_error_utils-2.7.0.tar.gz"
    sha256 "07107af2a2c26706cd9525b7ffbed43f2d07b50d27e39f9e9156c11b2e993c97"
  end

  resource "aws-sso-lib" do
    url "https:files.pythonhosted.orgpackages3ddf302bafc5e7182212eec091269c4731bb4469041a1db5e6c3643d089d135daws_sso_lib-1.14.0.tar.gz"
    sha256 "b0203a64ccb66ba78f99ef3d0eb669affe7bc323f6ab9caac97f35c21a03cea5"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackagescdf503bfbb89af1266a10125ebbc2bb09e2d276450de0e360767e7edb0d54022boto3-1.34.109.tar.gz"
    sha256 "98d389562e03a46fd79fea5f988e9e6032674a0c3e9e42c06941ec588b7e1070"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages7aaf091991a0420d70e150012fdee651185c7a0a3de8d96ad626b0ec9e35b704botocore-1.34.109.tar.gz"
    sha256 "804821252597821f7223cb3bfca2a2a513ae0bb9a71e8e22605aff6866e13e71"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages6911a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "pyrsistent" do
    url "https:files.pythonhosted.orgpackagesce3a5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95capyrsistent-0.20.0.tar.gz"
    sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagesd8c1f32fb7c02e7620928ef14756ff4840cae3b8ef1d62f7e596bc5413300a16requests-2.32.1.tar.gz"
    sha256 "eb97e87e64c79e64e5b8ac75cee9dd1f97f49e289b083ee6be96268930725685"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages83bcfb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesd64fb10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aedsetuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    cmd = "#{bin}aws-sso-util configure profile invalid " \
          "--sso-start-url https:example.comstart --sso-region eu-west-1 " \
          "--account-id 000000000000 --role-name InvalidRole " \
          "--region eu-west-1 --non-interactive"

    assert_empty shell_output "AWS_CONFIG_FILE=#{testpath}config #{cmd}"

    assert_predicate testpath"config", :exist?

    expected = <<~EOS

      [profile invalid]
      sso_start_url = https:example.comstart
      sso_region = eu-west-1
      sso_account_id = 000000000000
      sso_role_name = InvalidRole
      region = eu-west-1
      credential_process = aws-sso-util credential-process --profile invalid
    EOS

    assert_equal expected, (testpath"config").read
  end
end