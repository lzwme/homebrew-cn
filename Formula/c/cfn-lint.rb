class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/d7/c5/96dcb6bff4348b8928c0c62a4fa6d732fda8fe3324ca6d1c36058230e74b/cfn-lint-0.83.4.tar.gz"
  sha256 "fe386419ec2c92ffd795a9d1e1bea8131c9c8fae90e7a823f43da2fff82e9af7"
  license "MIT-0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3c41c9410d2c04ebf11625546e37ded17f08252b9c3468b67725b73b9d0f5bfc"
    sha256 cellar: :any,                 arm64_ventura:  "724f5a0b56ef363762d06c57596dd33b551d3a91215ec4d7ea55cd6c361a7dcf"
    sha256 cellar: :any,                 arm64_monterey: "2a9be90d67f60cfb494ab686046a38569001f328f76a2c412651b7952175fb69"
    sha256 cellar: :any,                 sonoma:         "9fff97c027e868f387754f6c82893caf3e4e0f02ad22165c0da1692f93d9d72d"
    sha256 cellar: :any,                 ventura:        "98b68b94b1b2a05fa52893c6a909b331370854b6fa877f46579661422445c563"
    sha256 cellar: :any,                 monterey:       "9663926f2af4c18d739b52c96320f63698bd9088fe2d5473872717702df779f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc86acc3c1e7dcd54c3f5ba3d112d7dbca7a56273939142ddd9a1b01ab8a5238"
  end

  depends_on "rust" => :build
  depends_on "python-attrs"
  depends_on "python-dateutil"
  depends_on "python-networkx"
  depends_on "python-pbr"
  depends_on "python-sympy"
  depends_on "python-typing-extensions"
  depends_on "python-urllib3"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/26/a3/a6238f1fbc6b8b612dca5207b7692cd92e8260c79a3e8314f654e35d528e/aws-sam-translator-1.81.0.tar.gz"
    sha256 "a5e268673d4d17cd1609f823fa9779aaf0103c47971a03a4eab6414b08c702fa"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/b1/e0/3cf846e1c39489f8250cd032514e0c1821d326a00002e06b94252c9f526c/boto3-1.33.6.tar.gz"
    sha256 "4f62fc1c7f3ea2d22917aa0aa07b86f119abd90bed3d815e4b52fb3d84773e15"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/04/6c/540ecba244f342206d72e7d22328f2ceea33f3f8bac89c8fac463c15e4aa/botocore-1.33.6.tar.gz"
    sha256 "938056bab831829f90e09ecd70dd6b295afd52b1482f5582ee7a11d8243d9661"
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
    url "https://files.pythonhosted.org/packages/6e/92/62fdc2f6b468b870dd171ad21748ef0ec2bff1b258c25ce6db3545cccc90/jsonpickle-3.0.2.tar.gz"
    sha256 "e37abba4bfb3ca4a4647d28bb9f4706436f7b46c8a8333b4a718abafa8e46b37"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/8f/5e/67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bc/jsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/a8/74/77bf12d3dd32b764692a71d4200f03429c41eee2e8a9225d344d91c03aff/jsonschema-4.20.0.tar.gz"
    sha256 "4f614fd46d8d61258610998997743ec5492a648b33cf478c1ddc23ed4598a5fa"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/8c/ce/1eb873a0ba153cf327464c752412b42d11b9c889d208beca7ef75540d128/jsonschema_specifications-2023.11.2.tar.gz"
    sha256 "9472fc4fea474cd74bea4a2b190daeccb5a9e4db2ea80efcf7a1b582fc9a81b8"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/b7/41/3c8108f79fb7da2d2b17f35744232af4ffcd9e764ebe1e3fd4b26669b325/pydantic-2.5.2.tar.gz"
    sha256 "ff177ba64c6faf73d7afa2e8cad38fd456c0dbe01c9954e71038001cd15a6edd"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/64/26/cffb93fe9c6b5a91c497f37fae14a4b073ecbc47fc36a9979c7aa888b245/pydantic_core-2.14.5.tar.gz"
    sha256 "6d30226dfc816dd0fdf120cae611dd2215117e4f9b124af8c60ab9093b6e8e71"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/80/ce/e99def6196f53af8de12a9c36968de32f80b7871084d677d0dfcd2762d0b/referencing-0.31.1.tar.gz"
    sha256 "81a1471c68c9d5e3831c30ad1dd9815c45b558e596653db751a2bfdd17b3b9ec"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/48/0b/f42f99419c5150c2741fe28bf97674d928d46ee17f46f2bc5be031cce0bc/rpds_py-0.13.2.tar.gz"
    sha256 "f8eae66a1304de7368932b42d801c67969fd090ddb1a7a24f27b435ed4bed68f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/5f/cc/7e3b8305e22d7dcb383d4e1a30126cfac3d54aea2bbd2dfd147e2eff4988/s3transfer-0.8.2.tar.gz"
    sha256 "368ac6876a9e9ed91f6bc86581e319be08188dc60d50e0d56308ed5765446283"
  end

  resource "sarif-om" do
    url "https://files.pythonhosted.org/packages/ba/de/bbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78c/sarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
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