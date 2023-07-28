class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/5d/31/81b5693eb8825e646e6fde177c8ea486b99f613c548a99052961a53e2597/cfn-lint-0.79.3.tar.gz"
  sha256 "4197507bcb0f03d14acc4e7fa5487b7e2ccaba276a167cda0e364c4758c5ddaa"
  license "MIT-0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcfbe57a3c54e9a0e2feb729dbf02efe0e3bcdffa70281fca46c93bab4625ead"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a33081ecb39f1418628da3774458368f42d2a2d3e31f414dd67b0a29c8b6d1d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed9e4b7b0d02a97e43d9a5fe2bd0e42c45cd5646b40985fae95e4bc3dd7ab74d"
    sha256 cellar: :any_skip_relocation, ventura:        "7a6cba8edd4a110d5d7ba6417a5326bcc392d5209bd7d205f547c88a58162f7e"
    sha256 cellar: :any_skip_relocation, monterey:       "680ceed7d4f059a7d19cd4d11926f6405b1a14cded546d204efea652a15dd066"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef8437948a511437df45f1e9e0b1edea01053cb7bc9d98d825f39ab19605ba6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f64d3a9d2986a52a8b16ae31a5006e4e91d8856bfdb2190e76ee3e1e91362e8a"
  end

  depends_on "rust" => :build
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/75/8c/ef4fa9ca2e395489c74c53cbc0084791e00b79940a8396622fcc00facc5f/aws-sam-translator-1.71.0.tar.gz"
    sha256 "a3ea80aeb116d7978b26ac916d2a5a24d012b742bf28262b17769c4b886e8fba"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/54/1e/05da54a9c1935e9e26e8cfe0b45a5bed2cb6ab0f798ae9c38bad58766245/boto3-1.28.12.tar.gz"
    sha256 "d5ac6599951fdd519ed26c6fe15c41a7aa4021cb9adce33167344f8ce5cdb07b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/a0/52/27fa7dd194cdf86f5412b623e03e81c249494efcf2d355b6fcc49ce144a5/botocore-1.31.12.tar.gz"
    sha256 "7e5db466c762a071bb58c9a39d070f1333ce4f4ba6fdf9820ba21e87bd4c7e29"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jschema-to-python" do
    url "https://files.pythonhosted.org/packages/1d/7f/5ae3d97ddd86ec33323231d68453afd504041efcfd4f4dde993196606849/jschema_to_python-1.2.3.tar.gz"
    sha256 "76ff14fe5d304708ccad1284e4b11f96a658949a31ee7faed9e0995279549b91"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/2b/3f/dd9bc9c1c9e57c687e8ebc4723e76c48980004244cf8db908a7b2543bd53/jsonpickle-3.0.1.tar.gz"
    sha256 "032538804795e73b94ead410800ac387fdb6de98f8882ac957fcd247e3a85200"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/8f/5e/67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bc/jsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/a1/47b974da1a73f063c158a1f4cc33ed0abf7c04f98a19050e80c533c31f0c/networkx-3.1.tar.gz"
    sha256 "de346335408f84de0eada6ff9fafafff9bcda11f0a0dfaa931133debb146ab61"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/3b/9b/a7631bf35e55326fd74654fe6bd896478f47d65e97ca69e60ddb1b3823ee/pydantic-1.10.12.tar.gz"
    sha256 "0fe8a415cea8f340e7a9af9c54fc71a649b43e8ca3cc732986116b3cb135d303"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/18/df/401fd39ffd50062ff1e0344f95f8e2c141de4fd1eca1677d2f29609e5389/regex-2023.6.3.tar.gz"
    sha256 "72d1a25bf36d2050ceb35b517afe13864865268dfb45910e2e17a84be6cbfeb0"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
  end

  resource "sarif-om" do
    url "https://files.pythonhosted.org/packages/ba/de/bbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78c/sarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/e5/57/3485a1a3dff51bfd691962768b14310dae452431754bfc091250be50dd29/sympy-1.12.tar.gz"
    sha256 "ebf595c8dac3e0fdc4152c51878b498396ec7f30e7a914d6071e674d49420fb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.yml").write <<~EOS
      ---
      AWSTemplateFormatVersion: '2010-09-09'
      Resources:
        # Helps tests map resource types
        IamPipeline:
          Type: "AWS::CloudFormation::Stack"
          Properties:
            TemplateURL: !Sub 'https://s3.${AWS::Region}.amazonaws.com/bucket-dne-${AWS::Region}/${AWS::AccountId}/pipeline.yaml'
            Parameters:
              DeploymentName: iam-pipeline
              Deploy: 'auto'
    EOS
    system bin/"cfn-lint", "test.yml"
  end
end