class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/6b/b0/3319a660166d7f1cde544455f63576328395d479bd3f2c4534fac7aecab5/cfn-lint-0.83.3.tar.gz"
  sha256 "cb1b5da6f3f15742f07f89006b9cc6ca459745f350196b559688ac0982111c5f"
  license "MIT-0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "f72a66960b55894f5b2547ff122782242ef7497286e7617efadc6d71aaf8ef62"
    sha256 cellar: :any,                 arm64_ventura:  "0aaf3b523fd755a4fc49d176daf2b2c983c72e4e0d98e1824d50514c339365b3"
    sha256 cellar: :any,                 arm64_monterey: "dc078af592de2029063bef1ca76b1a6fc231c2d4b3c3be39f1429277626feef3"
    sha256 cellar: :any,                 sonoma:         "e1fe401fd0704c03f25a9fa9cfb622e0ee6bf4459229fcb5fa67de7a80f80a1d"
    sha256 cellar: :any,                 ventura:        "18fbbe0caa1da62c6e4636545fd27dfec4f47938bfdaf8fb51ca11442a9486ed"
    sha256 cellar: :any,                 monterey:       "8e8e94e35bfe3165fb9f0c8ffd4f4eb959bdc57e78c8386cdc11e41aae82c325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd77828fdca8a17a3cb00953c7cb2fe696c76e1a938788185e1bd71576f9eaa4"
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
    url "https://files.pythonhosted.org/packages/79/3d/7168d757744fc624115a9fbfd9a8b387bf94db6077a1f831c2792d84b8b2/aws-sam-translator-1.79.0.tar.gz"
    sha256 "990f3043d00b6fd801b38ad780ecd058c315b7581b2e43fc013c9b6253f876e8"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/07/2d/6b217bb14849a79d6c419b96518e55252995b9857b1df52b952cbabe066b/boto3-1.29.0.tar.gz"
    sha256 "3e90ea2faa3e9892b9140f857911f9ef0013192a106f50d0ec7b71e8d1afc90a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9b/e9/84ae72bafa96fe7b6d7e5dd3cb2a97cf1ff75eea5ceb0b870b6c1d37e442/botocore-1.32.0.tar.gz"
    sha256 "95fe3357b9ddc4559941dbea0f0a6b8fc043305f013b7ae2a85dff0c3b36ee92"
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
    url "https://files.pythonhosted.org/packages/95/18/618159fb2efbe3fb2cd32b16c40278954cde94744957734ef0482286a052/jsonschema-4.19.2.tar.gz"
    sha256 "c9ff4d7447eed9592c23a12ccee508baf0dd0d59650615e847feb6cdca74f392"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/d4/84/8f5072792a260016048d3a5ae5186ec3be9e090480ddf5446484394dd8c3/jsonschema_specifications-2023.11.1.tar.gz"
    sha256 "c9b234904ffe02f079bf91b14d79987faa685fd4b39c377a0996954c0090b9ca"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/0b/6c/cebf0e87ee0f2496584e04079592f33610f1f9aaf3684cb3105f03969e2b/pydantic-2.5.1.tar.gz"
    sha256 "0b8be5413c06aadfbe56f6dc1d45c9ed25fd43264414c571135c97dd77c2bedb"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/4c/ee/b3479b31f47226bae5d9033761971bec215774a6078ce08e8618d6381470/pydantic_core-2.14.3.tar.gz"
    sha256 "3ad083df8fe342d4d8d00cc1d3c1a23f0dc84fce416eb301e69f1ddbbe124d3f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/61/11/5e947c3f2a73e7fb77fd1c3370aa04e107f3c10ceef4880c2e25ef19679c/referencing-0.31.0.tar.gz"
    sha256 "cc28f2c88fbe7b961a7817a0abc034c09a1e36358f82fedb4ffdf29a25398863"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/75/be/e3f366aa4cd1e3a814f136773e506fc5423eff903ef0372a251df34e6e45/rpds_py-0.12.0.tar.gz"
    sha256 "7036316cc26b93e401cedd781a579be606dad174829e6ad9e9c5a0da6e036f80"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
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