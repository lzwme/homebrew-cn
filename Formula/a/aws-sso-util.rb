class AwsSsoUtil < Formula
  include Language::Python::Virtualenv

  desc "Smooth out the rough edges of AWS SSO (temporarily, until AWS makes it better)"
  homepage "https://github.com/benkehoe/aws-sso-util"
  url "https://files.pythonhosted.org/packages/6e/93/90d3753ac7ea3148c41c43929cace11d8fc1331c629497ab24a91a6c3724/aws_sso_util-4.32.0.tar.gz"
  sha256 "2649dcf3c594851a0c55ed6ebf2df70205d1debd6e58e263738430d4703890ec"
  license "Apache-2.0"
  revision 2
  head "https://github.com/benkehoe/aws-sso-util.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5017f2593b2f027f610521a11d557f0262df6f321b890c909ceac0e189aecf66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10d98ba3f1468c5963edc03341024595b901f3899d3b4df430d44d36aee1cbfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7214df966f60e3c4a4113d6a2ffdc37023d1a6e1806b4d2207ae4267b8257b3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c76cd44d175d11bc86eb0d879c6bf85e6e2b2ec92e2fd8a62d4c38f33a25a77a"
    sha256 cellar: :any_skip_relocation, ventura:        "dce9ca35ddb6c7732ccac682af4941a113c4579c37791936eff31b3319118493"
    sha256 cellar: :any_skip_relocation, monterey:       "9b765ea3da4d65b57868ab70e1f54224970bb69890e239501e317e33bffdd7f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4948938b9317396477625650d142779870d5eb8f87071e14cbe9a006b833d20b"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "aws-error-utils" do
    url "https://files.pythonhosted.org/packages/2a/fc/2541892cafad6658e9ce5226e54088eff9692cbe4a32cd5a7dfec5846cbf/aws_error_utils-2.7.0.tar.gz"
    sha256 "07107af2a2c26706cd9525b7ffbed43f2d07b50d27e39f9e9156c11b2e993c97"
  end

  resource "aws-sso-lib" do
    url "https://files.pythonhosted.org/packages/3d/df/302bafc5e7182212eec091269c4731bb4469041a1db5e6c3643d089d135d/aws_sso_lib-1.14.0.tar.gz"
    sha256 "b0203a64ccb66ba78f99ef3d0eb669affe7bc323f6ab9caac97f35c21a03cea5"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/67/c6/0baa9f7193b6defe6238b5b1b512be434cb54bdb32f949b8d8823e860e2c/boto3-1.28.64.tar.gz"
    sha256 "a5cf93b202568e9d378afdc84be55a6dedf11d30156289fe829e23e6d7dccabb"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/01/98/3635fd827cd7f758d2010e7bb432853c37b14d58b7bc728d0797d0199480/botocore-1.31.64.tar.gz"
    sha256 "d8eb4b724ac437343359b318d73de0cfae0fecb24095827e56135b0ad6b44caf"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    cmd = "#{bin}/aws-sso-util configure profile invalid " \
          "--sso-start-url https://example.com/start --sso-region eu-west-1 " \
          "--account-id 000000000000 --role-name InvalidRole " \
          "--region eu-west-1 --non-interactive"

    assert_empty shell_output "AWS_CONFIG_FILE=#{testpath}/config #{cmd}"

    assert_predicate testpath/"config", :exist?

    expected = <<~EOS

      [profile invalid]
      sso_start_url = https://example.com/start
      sso_region = eu-west-1
      sso_account_id = 000000000000
      sso_role_name = InvalidRole
      region = eu-west-1
      credential_process = aws-sso-util credential-process --profile invalid
    EOS

    assert_equal expected, (testpath/"config").read
  end
end