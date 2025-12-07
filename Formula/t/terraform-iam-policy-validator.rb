class TerraformIamPolicyValidator < Formula
  include Language::Python::Virtualenv

  desc "CLI to validate AWS IAM policies in Terraform templates for best practices"
  homepage "https://github.com/awslabs/terraform-iam-policy-validator"
  url "https://files.pythonhosted.org/packages/89/6b/bdb90f2fcb4a0033f138d52d5b24af9a2f8a84703ef94cbc31d51f0afaed/tf_policy_validator-0.0.9.tar.gz"
  sha256 "ec8496bb8d45642a61f36dba95c867ac8ca5438bfc5bebafe8e3eec03a50d181"
  license "MIT-0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "437c5ff4f25dc62b5c1a5bde0d9266e21e81f337e3f0745cee8efb38fc74e883"
    sha256 cellar: :any,                 arm64_sequoia: "59abe7788c086800af67f08681515e41f71b050b5ef64425126a9579e803baad"
    sha256 cellar: :any,                 arm64_sonoma:  "6fd3ebeaa9d5e0aee127b7b078a1e6149f7e3d4c1948f9ba06401d93429e7fb2"
    sha256 cellar: :any,                 sonoma:        "963031588714f6c02217f44eb9b96cde1ee440404ada7aeec8772c51be794285"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3baaa856c2cd7c6ba3022cb2370ba3e2e795b3d05841f2dec4bc94596b3b316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e69109b409174b41b398ac204327b93afa497ce79d9d541fbe076d1f949fc54e"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f3/31/246916eec4fc5ff7bebf7e75caf47ee4d72b37d4120b6943e3460956e618/boto3-1.42.4.tar.gz"
    sha256 "65f0d98a3786ec729ba9b5f70448895b2d1d1f27949aa7af5cb4f39da341bbc4"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/5c/b7/dec048c124619b2702b5236c5fc9d8e5b0a87013529e9245dc49aaaf31ff/botocore-1.42.4.tar.gz"
    sha256 "d4816023492b987a804f693c2d76fb751fdc8755d49933106d69e2489c4c0f98"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
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
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1c/43/554c2569b62f49350597348fc3ac70f786e3c32e7f19d266e19817812dd3/urllib3-2.6.0.tar.gz"
    sha256 "cb9bcef5a4b345d5da5d145dc3e30834f58e8018828cbc724d30b4cb7d4d49f1"
  end

  def install
    # hatch does not support a SOURCE_DATE_EPOCH before 1980.
    # Remove after https://github.com/pypa/hatch/pull/1999 is released.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources
  end

  test do
    (testpath/"default.yaml").write <<~YAML
      settings:
        example_key: example_value
    YAML

    (testpath/"tf.json").write <<~JSON
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
                "provider_name": "registry.terraform.io/hashicorp/aws",
                "values": {
                  "policy": "{\\"Version\\":\\"2012-10-17\\",\\"Statement\\":[{\\"Effect\\":\\"Allow\\",\\"Action\\":[\\"s3:GetObject\\"],\\"Resource\\":\\"arn:aws:s3:::mybucket/*\\"}]}"
                }
              }
            ]
          }
        }
      }
    JSON

    output = shell_output("#{bin}/tf-policy-validator validate " \
                          "--config default.yaml --template-path tf.json --region us-east-1 2>&1", 1)
    assert_match "No IAM policies defined", output
  end
end