class Cfripper < Formula
  include Language::Python::Virtualenv

  desc "Library and CLI tool to analyse CloudFormation templates for security issues"
  homepage "https://cfripper.readthedocs.io"
  url "https://files.pythonhosted.org/packages/fd/1e/a27bad490eff8d1d32db795ee1dbd664e33b727f7e45b5bd44a2bfdc978a/cfripper-1.18.0.tar.gz"
  sha256 "755bcbaf4ab8d923ffe8b02c36a3b6b74770c6c4a16b0c0917bb104e49e05656"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "23e5c209e0679517f1c87eb9476f1dcdd6bb887ae9325621f38903f69948027a"
    sha256 cellar: :any,                 arm64_sequoia: "9ca80d3871e4ca0d37234cd42d24959f270af332ef316590a793517a2e5524a5"
    sha256 cellar: :any,                 arm64_sonoma:  "ccc22c9cb2a98a3c7b6ea67e9c275540022c5c0e82b07b97677f0e57631f873e"
    sha256 cellar: :any,                 sonoma:        "260f53faad82a0ea2dac2d2e9db4ce1b554da99e083aeab20da2afd7ccfb3b3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9a53b71a01d29440043bd016a9fed1838d9b33597e1dd6d1dfe33106ee14195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b364291a8a8a8a35b7bc425ca8993a5cfeeedb37cb963190a497c726b0a2e30c"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "libyaml"
  depends_on "python@3.14"

  # `pluggy` is manually updated to support Python 3.14

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/5c/89/36c09108d8d35e6f722cdc9ff169f003c7458657ecf04c3a375dca973ccb/boto3-1.40.54.tar.gz"
    sha256 "5f7dbf8539d26e0ee973baea49d0db8c1ee57707a785c5a23307241fdba04327"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/d1/c8/8c7509d7fa26de03d21673f18a1edc1ac98198ba261a2b943774ed4f1c44/botocore-1.40.54.tar.gz"
    sha256 "808232d9fcbf2c295b6e7cd1897119ee2fb97e756edfb313aa6d27ba0b281c66"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pycfmodel" do
    url "https://files.pythonhosted.org/packages/7b/a4/82753381cef5f9b0153a730b426fc5adfa272ff612d6d4fd150a037231f8/pycfmodel-1.1.3.tar.gz"
    sha256 "f42a2a05ab23dd3e204176037d359de6ec84a493a36d640a5beb86b4947e8880"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/8d/35/d319ed522433215526689bad428a94058b6dd12190ce7ddd78618ac14b28/pydantic-2.12.2.tar.gz"
    sha256 "7b8fa15b831a4bbde9d5b84028641ac3080a4ca2cbd4a621a661687e741624fd"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/df/18/d0944e8eaaa3efd0a91b0f1fc537d3be55ad35091b6a87638211ba691964/pydantic_core-2.41.4.tar.gz"
    sha256 "70e47929a9d4a1905a67e4b687d5946026390568a8e952b92824118063cee4d5"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/2f/24/91c037f47e434172c2112d65c00c84d475a6715425e3315ba2cbb7a87e66/pydash-8.0.5.tar.gz"
    sha256 "7cc44ebfe5d362f4f5f06c74c8684143c5ac481376b059ff02570705523f9e2e"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cfripper", shell_parameter_format: :click)
  end

  test do
    (testpath/"test.json").write <<~JSON
      {
        "AWSTemplateFormatVersion": "2010-09-09",
        "Resources": {
          "RootRole": {
            "Type": "AWS::IAM::Role",
            "Properties": {
              "AssumeRolePolicyDocument": {
                "Version": "2012-10-17",
                "Statement": [
                  {
                    "Effect": "Allow",
                    "Principal": {
                      "AWS": "arn:aws:iam::999999999:role/someuser@bla.com"
                    },
                    "Action": "sts:AssumeRole"
                  }
                ]
              },
              "Path": "/",
              "Policies": []
            }
          }
        }
      }
    JSON

    output = shell_output("#{bin}/cfripper #{testpath}/test.json --format txt 2>&1")
    assert_match "no AWS Account ID was found in the config.", output
    assert_match "Valid: True", output

    assert_match version.to_s, shell_output("#{bin}/cfripper --version")
  end
end