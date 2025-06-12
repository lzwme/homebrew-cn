class TerraformIamPolicyValidator < Formula
  include Language::Python::Virtualenv

  desc "CLI to validate AWS IAM policies in Terraform templates for best practices"
  homepage "https:github.comawslabsterraform-iam-policy-validator"
  url "https:files.pythonhosted.orgpackages896bbdb90f2fcb4a0033f138d52d5b24af9a2f8a84703ef94cbc31d51f0afaedtf_policy_validator-0.0.9.tar.gz"
  sha256 "ec8496bb8d45642a61f36dba95c867ac8ca5438bfc5bebafe8e3eec03a50d181"
  license "MIT-0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4b0cecd4db6c316acf78e7388a5935c24a07b569d530f741025dbc77b18a8772"
    sha256 cellar: :any,                 arm64_sonoma:  "406d9d44a6e7c4ea39254a5dad5de662538849dfd9ddaf358d41b6e224068e86"
    sha256 cellar: :any,                 arm64_ventura: "f35b085934dff7cd7f02236c7da07fab2caf9a2d8026c75fb3a494e8ec2a2c2b"
    sha256 cellar: :any,                 sonoma:        "a74b95c1e83a7bc83446885f87ba91e64c68e0b96b6a40ae68b1550fcdc737aa"
    sha256 cellar: :any,                 ventura:       "0a2bffe8b19bb0e3115755283b0ed676487d5878b7b645ce001f2ed2a7eb7305"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c72485514e41a2e56f09c9c138107e0d2616ce894d5e342968a5f5919331230c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf2a79bef90563ce0712d9637a352ed4ff602c5051ed5e5ed646f603ae77274a"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "boto3" do
    url "https:files.pythonhosted.orgpackagesad9599046c55799732d97b0f9a0bb99b64760f07dd55ac793393a6c4e847d8d6boto3-1.38.33.tar.gz"
    sha256 "6467909c1ae01ff67981f021bb2568592211765ec8a9a1d2c4529191e46c3541"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages9daa1521d7e1dcb76af8dca81539eec141ee3581a32e0dc1f31d092b59feb06abotocore-1.38.33.tar.gz"
    sha256 "dbe8fea9d0426c644c89ef2018ead886ccbcc22901a02b377b4e65ce1cb69a2b"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesed5d9dcc100abc6711e8247af5aa561fc07c4a046f72f659c3adea9a449e191as3transfer-0.13.0.tar.gz"
    sha256 "f5e6db74eb7776a37208001113ea7aa97695368242b364d73e91c981ac522177"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources
  end

  test do
    (testpath"default.yaml").write <<~YAML
      settings:
        example_key: example_value
    YAML

    (testpath"tf.json").write <<~JSON
      {
        "format_version": "1.0",
        "terraform_version": "1.0.0",
        "planned_values": {
          "root_module": {
            "resources": [
              {
                "address": "aws_iam_policy.example",
                "mode": "managed",
                "type": "aws_iam_policy",
                "name": "example",
                "provider_name": "registry.terraform.iohashicorpaws",
                "values": {
                  "policy": "{\\"Version\\":\\"2012-10-17\\",\\"Statement\\":[{\\"Effect\\":\\"Allow\\",\\"Action\\":[\\"s3:GetObject\\"],\\"Resource\\":\\"arn:aws:s3:::mybucket*\\"}]}"
                }
              }
            ]
          }
        }
      }
    JSON

    output = shell_output("#{bin}tf-policy-validator validate " \
                          "--config default.yaml --template-path tf.json --region us-east-1 2>&1", 1)
    assert_match "No IAM policies defined", output
  end
end