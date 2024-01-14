class AwsSsoUtil < Formula
  include Language::Python::Virtualenv

  desc "Smooth out the rough edges of AWS SSO (temporarily, until AWS makes it better)"
  homepage "https:github.combenkehoeaws-sso-util"
  url "https:files.pythonhosted.orgpackages6e9390d3753ac7ea3148c41c43929cace11d8fc1331c629497ab24a91a6c3724aws_sso_util-4.32.0.tar.gz"
  sha256 "2649dcf3c594851a0c55ed6ebf2df70205d1debd6e58e263738430d4703890ec"
  license "Apache-2.0"
  revision 4
  head "https:github.combenkehoeaws-sso-util.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bf2c009179ecad087e410e540c3c985456496feea3c09d21188f2b88de4b221"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dd7cd311614d7c0e9f1ee94c95f4b680fbe49014862e498333be79d74f1ed91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62d06aee6fc1e986b5d97ea05113a2f205eb7ae827d4a1b6f1c37cec2d542b1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "432b66d82718b9e845b49600f8adcaa5babf14f0537ac1c4b1e067a1712dc6b1"
    sha256 cellar: :any_skip_relocation, ventura:        "94145a5e9f4fc4ea63b9cd0f66f6830cbc20fb6a2ae232c9160b768dfdafb018"
    sha256 cellar: :any_skip_relocation, monterey:       "adbf86c38eb72ad49acfe0a3e33cdba81fec7665e986e76ab26d1d3651d8e02a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0a7730a7f27adeacf7b1e865dd123eed763996ba7d3143ad475557a5aeaf84c"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

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
    url "https:files.pythonhosted.orgpackages8f82a0b568542639f1c2df5438ddb67dca42ce7b5fd9cc0a86045d910dcc002fboto3-1.34.17.tar.gz"
    sha256 "8ca248cc84e7e859e4e276eb9c4309fa01a3e58473bf48d6c33448be870c2bb8"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages5ab46fbeafeae332dff07ff2b9898daae54abf4eb3558acb178548c476d8b4f3botocore-1.34.17.tar.gz"
    sha256 "e48a662f3a6919219276b55085e8f73c3347966675f55e9d448be30cf79678ee"
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
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesa0b54c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40bas3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesfcc9b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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