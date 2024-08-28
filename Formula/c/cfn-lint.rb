class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https:github.comaws-cloudformationcfn-lint"
  url "https:files.pythonhosted.orgpackagesf96178e4c6d7f88b8f155d5612008c2e6bbcd8b0d1ccf5ebcc4ba3d2211eb938cfn_lint-1.11.0.tar.gz"
  sha256 "4e276e28df09a0e4a521c544ed4ded61c899c747095d9d46d7df6f5ab9ead171"
  license "MIT-0"

  livecheck do
    url :stable
    regex(href=.*?cfn_lint[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e5e6f384f63a8e52fea7deb5f0900636b290a2adad7877a946eb11757162070e"
    sha256 cellar: :any,                 arm64_ventura:  "d1f888f0ad48dc15332d1fe09e59f6d7826e4c3c9f98b36292482ee8a2b76b89"
    sha256 cellar: :any,                 arm64_monterey: "1240d13feb9eb604c205dc2d001cd92d86e02cb87aeadb0c6be928a32278e7e2"
    sha256 cellar: :any,                 sonoma:         "6c156aae2ddface73d5ef53a99162fc4ba623e115584524101512ced3ca29a8f"
    sha256 cellar: :any,                 ventura:        "95a84a9d2bb5b0c82afbec394ee8bf0252a2604dc94df23487f66a835220aa76"
    sha256 cellar: :any,                 monterey:       "0acd8db015c42cd77f841b2e3268636339038c82e5bba69b0e022777ab1d5a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "828cb8f7c59f0978d63377e63c96b766bd6023fe865b44ac1194b38c5adcebc9"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "aws-sam-translator" do
    url "https:files.pythonhosted.orgpackages1c41fbd5be5d25c6bdceb92ecb5232a794eb7a3a9cfdf111f28b27cb3c19fb77aws_sam_translator-1.91.0.tar.gz"
    sha256 "0cdfbc598f384c430c3ec064f6008d80c5a0d58f1dc45ca4e331ae5c43cb4697"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages59d295729dcca737eccb19bfefdd9a2fa89beb9263e84e9543163349f7007090boto3-1.35.7.tar.gz"
    sha256 "05bd349cf260ba177924f38d721e427e2b3a6dd0fa8a18fa4ffc1b889633b181"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackagesd12f9da463c355b1f744223383c8efc817a6db1789341a842cfdbf1522840684botocore-1.35.7.tar.gz"
    sha256 "85e4b58f2c6e54dfbf52eaee72ebc9b70188fd1716d47f626874abadcee45512"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonpatch" do
    url "https:files.pythonhosted.orgpackages427818813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https:files.pythonhosted.orgpackages6a0aeebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "mpmath" do
    url "https:files.pythonhosted.orgpackagese047dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackages04e6b164f94c869d6b2c605b5128b7b0cfe912795a87fc90e78533920001f3ecnetworkx-3.3.tar.gz"
    sha256 "0c127d8b2f4865f59ae9cb8aafcd60b5c70f3241ebd66f7defad7c4ab90126c9"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages8c99d0a5dca411e0a017762258013ba9905cd6e7baa9a3fd1fe8b6529472902epydantic-2.8.2.tar.gz"
    sha256 "6f62c13d067b0755ad1c21a34bdd06c0c12625a22b0fc09c6b149816604f7c2a"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages12e30d5ad91211dba310f7ded335f4dad871172b9cc9ce204f5a56d76ccd6247pydantic_core-2.20.1.tar.gz"
    sha256 "26ca695eeee5f9f1aeeb211ffc12f10bcb6f71e2989988fda61dabd65db878d4"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages995b73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6dreferencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages3f5164256d0dc72816a4fe3779449627c69ec8fee5a5625fd60ba048f53b3478regex-2024.7.24.tar.gz"
    sha256 "9cfd009eed1a46b27c14039ad5bbc5e71b6367c5b2e6d5f5da0ea91600817506"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages5564b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29arpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagescb6794c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fabs3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sympy" do
    url "https:files.pythonhosted.orgpackages94154a041424c7187f41cce678f5a02189b244e9aac61a18b45cd415a3a470f3sympy-1.13.2.tar.gz"
    sha256 "401449d84d07be9d0c7a46a64bd54fe097667d5e7181bfe67ec777be9e01cb13"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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