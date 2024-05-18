class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https:github.comaws-cloudformationcfn-lint"
  url "https:files.pythonhosted.orgpackages513b6e25b45342f6e929cfaf873355d21d278e41afd78aa9a4cbe0c0cc8cc6a9cfn_lint-0.87.3.tar.gz"
  sha256 "4c4f1717cba9b9b579f95687ffa71a8d740b7e1712f6e315c723aac9bb0279d7"
  license "MIT-0"

  livecheck do
    url :stable
    regex(href=.*?cfn_lint[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "68d8e165bd9bb4fbeb6bfd870455f09cef14ec53991b4d5f9c9d209f31c68143"
    sha256 cellar: :any,                 arm64_ventura:  "b90ad0833effb61f30873f035b07875086bbef83892fed5c33a2d3398840fbff"
    sha256 cellar: :any,                 arm64_monterey: "66890fff830bd0a1f74d02106da6f6f9d82861d7a05e41fc16d81ac7e30a74c0"
    sha256 cellar: :any,                 sonoma:         "5f28043bdfa26471a53e4eb3e95410d3e6082ab7a3ece3d71a5a506a4a203acf"
    sha256 cellar: :any,                 ventura:        "ed4bd7d3c20795852bfe6ea0cdf3f20d81faeb5592a2870e283eb7bb2f3d363d"
    sha256 cellar: :any,                 monterey:       "2348f8ecdad5d3d3581af5d373215c11c6bb63ce9462a71dbbbe0bb606acc4f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2fb9a60d403188b10012108f68ca539b602d9fe20057df2ca65dc4591708a58"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackages67fe8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "aws-sam-translator" do
    url "https:files.pythonhosted.orgpackages0381448cc26a70366e681eeb4ae868e1e5519f5d2d3d8602dd69731f236cbd43aws_sam_translator-1.89.0.tar.gz"
    sha256 "fff1005d0b1f3cb511d0ac7e85f54af06afc9d9e433df013a2338d7a0168d174"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages2598c5a4931597f0a960a05ad1b3509d6286f33e34191a6fa58add18b34d247cboto3-1.34.107.tar.gz"
    sha256 "2500963ddd7fee0c891db596ed73f203a62e8ee6faf1543c7a14169b1d557bc3"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages8e5ae3ab5eb9efe70238cf0be3db8b56bc037d98fe01cfbdfe1374fa5d413e58botocore-1.34.107.tar.gz"
    sha256 "4620286a814c3c8abc59145203650a6b2a4f538e887552fa1bc6896b6d11b28b"
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
    url "https:files.pythonhosted.orgpackages724b8c2df97303521f99a0a2cc9be7373ee175dbc01d4befb653ff7b8d32b442jsonpickle-3.0.4.tar.gz"
    sha256 "a1b14c8d6221cd8f394f2a97e735ea1d7edc927fbd135b26f2f8700657c8c62b"
  end

  resource "jsonpointer" do
    url "https:files.pythonhosted.orgpackages8f5e67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bcjsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages19f11c1dc0f6b3bf9e76f7526562d29c320fa7d6a2f35b37a1392cc0acd58263jsonschema-4.22.0.tar.gz"
    sha256 "5b22d434a45935119af990552c862e5d6d564e8f6601206b305a61fdf661a2b7"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "junit-xml" do
    url "https:files.pythonhosted.orgpackages98afbc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "mpmath" do
    url "https:files.pythonhosted.orgpackagese047dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackages04e6b164f94c869d6b2c605b5128b7b0cfe912795a87fc90e78533920001f3ecnetworkx-3.3.tar.gz"
    sha256 "0c127d8b2f4865f59ae9cb8aafcd60b5c70f3241ebd66f7defad7c4ab90126c9"
  end

  resource "pbr" do
    url "https:files.pythonhosted.orgpackages8dc2ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages1f740d009e056c2bd309cdc053b932d819fcb5ad3301fc3e690c097e1de3e714pydantic-2.7.1.tar.gz"
    sha256 "e9dbb5eada8abe4d9ae5f46b9939aead650cd2b68f249bb3a8139dbe125803cc"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagese923a609c50e53959eb96393e42ae4891901f699aaad682998371348650a6651pydantic_core-2.18.2.tar.gz"
    sha256 "2e29d20810dfc3043ee13ac7d9e25105799817683348823f305ab3f349b9386e"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages995b73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6dreferencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages7adb5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49bregex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages2daae7c404bdee1db7be09860dff423d022ffdce9269ec8e6532cce09ee7beearpds_py-0.18.1.tar.gz"
    sha256 "dc48b479d540770c811fbd1eb9ba2bb66951863e448efec2e2c102625328e92f"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages83bcfb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "sarif-om" do
    url "https:files.pythonhosted.orgpackagesbadebbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78csarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sympy" do
    url "https:files.pythonhosted.orgpackagese5573485a1a3dff51bfd691962768b14310dae452431754bfc091250be50dd29sympy-1.12.tar.gz"
    sha256 "ebf595c8dac3e0fdc4152c51878b498396ec7f30e7a914d6071e674d49420fb8"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
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