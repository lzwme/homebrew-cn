class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https:github.comaws-cloudformationcfn-lint"
  url "https:files.pythonhosted.orgpackages0a7587b419149db1da90a32f11cfb3fc7faad9a87f4ca49b9a2694a03fe5edc7cfn-lint-0.84.0.tar.gz"
  sha256 "7a819ffa48ab23f775037ddb0d9330ba206d547439f69bc72f76f1183d8bc124"
  license "MIT-0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "96fcf885c3c8c708452973751353c58101551ccc20b52a847edda31a440519d7"
    sha256 cellar: :any,                 arm64_ventura:  "cbbc813effc3488ed13f142cc5bc6fe41d6328afa975fa68cd984ff8b596b928"
    sha256 cellar: :any,                 arm64_monterey: "c68aeb1d98fd93cf3b3116b94bd10a29def1560990b77dc5f281a6a58a05d910"
    sha256 cellar: :any,                 sonoma:         "58cc8ff3d98ff3aacd4276fd0098f73767a6a2f74a4d1a57363fa0cc7cfcfa29"
    sha256 cellar: :any,                 ventura:        "0b672e2f48c0b4dbd579c8638dcf59849a3a4c6f23493c4c39a7a5f9df255a60"
    sha256 cellar: :any,                 monterey:       "638aee477fab61463e0aa24f44f64e5cde03bb879605cfc664cc7ce0ece99c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc4a20e77a59a660365ee4caa55c77b67a1e70c16c70c75b27bd87577dca0902"
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
    url "https:files.pythonhosted.orgpackages67fe8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "aws-sam-translator" do
    url "https:files.pythonhosted.orgpackagesa2e7cb06a60db1843aa4c403c185c681622cc816aa003fa517274d3164c5eac3aws-sam-translator-1.83.0.tar.gz"
    sha256 "46025ca8894a56eacd87eb0e4f9af5c01c567c9a734b97fbba353bffd56ba5dc"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages1541ef925ff414b28fc55babb0df145cbee23e2f1e8896e4eab80c4f082f9289boto3-1.34.21.tar.gz"
    sha256 "206e61ba1f8c830e5df0355606d178ad5bc970df12c4c318b021c71da410eb0c"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages384b14c863acefe2b242f659cba1b7e58cba3f5bc9a5bda59e708714195be216botocore-1.34.21.tar.gz"
    sha256 "21983bb0473a19130192c50ec6974d55f0c4aa48a7094bcf40f7882c8b69b8f1"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jschema-to-python" do
    url "https:files.pythonhosted.orgpackages1d7f5ae3d97ddd86ec33323231d68453afd504041efcfd4f4dde993196606849jschema_to_python-1.2.3.tar.gz"
    sha256 "76ff14fe5d304708ccad1284e4b11f96a658949a31ee7faed9e0995279549b91"
  end

  resource "jsonpatch" do
    url "https:files.pythonhosted.orgpackages427818813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpickle" do
    url "https:files.pythonhosted.orgpackages6e9262fdc2f6b468b870dd171ad21748ef0ec2bff1b258c25ce6db3545cccc90jsonpickle-3.0.2.tar.gz"
    sha256 "e37abba4bfb3ca4a4647d28bb9f4706436f7b46c8a8333b4a718abafa8e46b37"
  end

  resource "jsonpointer" do
    url "https:files.pythonhosted.orgpackages8f5e67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bcjsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages44cd1d325d358d856da96a7c6cfc2af486b70587dc4c70594aa2a9e6c2d279adjsonschema-4.21.0.tar.gz"
    sha256 "3ba18e27f7491ea4a1b22edce00fb820eec968d397feb3f9cb61d5894bb38167"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "junit-xml" do
    url "https:files.pythonhosted.orgpackages98afbc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesaa3f56142232152145ecbee663d70a19a45d078180633321efb3847d2562b490pydantic-2.5.3.tar.gz"
    sha256 "b3ef57c62535b0941697cce638c08900d87fcb67e29cfa99e8a68f747f393f7a"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesb27d8304d8471cfe4288f95a3065ebda56f9790d087edc356ad5bd83c89e2d79pydantic_core-2.14.6.tar.gz"
    sha256 "1fd0c1d395372843fba13a51c28e3bb9d59bd7aebfeb17358ffaaa1e4dbbe948"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages81ce910573eca7b1a1c6358b0dc0774ce1eeb81f4c98d4ee371f1c85f22040a1referencing-0.32.1.tar.gz"
    sha256 "3c57da0513e9563eb7e203ebe9bb3a1b509b042016433bd1e45a2853466c3dd3"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackagesb53931626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackagesb70ae3bdcc977e6db3bf32a3f42172f583adfa7c3604091a03d512333e0161ferpds_py-0.17.1.tar.gz"
    sha256 "0210b2668f24c078307260bf88bdac9d6f1093635df5123789bfee4d8d7fc8e7"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesa0b54c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40bas3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "sarif-om" do
    url "https:files.pythonhosted.orgpackagesbadebbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78csarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.yml").write <<~EOS
      ---
      AWSTemplateFormatVersion: '2010-09-09'
      Resources:
        # Helps tests map resource types
        IamPipeline:
          Type: "AWS::CloudFormation::Stack"
          Properties:
            TemplateURL: !Sub 'https:s3.${AWS::Region}.amazonaws.combucket-dne-${AWS::Region}${AWS::AccountId}pipeline.yaml'
            Parameters:
              DeploymentName: iam-pipeline
              Deploy: 'auto'
    EOS
    system bin"cfn-lint", "test.yml"
  end
end