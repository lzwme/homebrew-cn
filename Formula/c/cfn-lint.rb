class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https:github.comaws-cloudformationcfn-lint"
  url "https:files.pythonhosted.orgpackages4179f36ce57fa501a49e42f536b9dc866457cd814a3b6688d2d5d02e18247bbbcfn_lint-1.22.1.tar.gz"
  sha256 "11085a8196ca1f381735782b4977be62a5860e26d3e0b578d2d4a244b9031b16"
  license "MIT-0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c005f050425eee6846bf224889cb245952f157689ae424cb450a2ebc6d0ff64"
    sha256 cellar: :any,                 arm64_sonoma:  "d7eef97876e9b0add90d4349a1a2355521da8ab7487585e7d456f036ffafa405"
    sha256 cellar: :any,                 arm64_ventura: "097c314dc00d5c7f2e07df16d2c2c7f11b8a054e9757edf787b1637dc9782859"
    sha256 cellar: :any,                 sonoma:        "d29910350656e9c7940790940dd69225e7aa55456b634df4e48c3508c1034d69"
    sha256 cellar: :any,                 ventura:       "639693b2ff79feafdf97292b1f8b8fe2bf817321af2adabf329c2cf22cc5fe50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "116b0f7329d80b82b6785898758c5a8c53ba7894b8d6643fb35296ce214b65f9"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "aws-sam-translator" do
    url "https:files.pythonhosted.orgpackagesef2c69276246bc22293aec595dac217e0ad8299053d05c8ff00a24d1f09395b3aws_sam_translator-1.94.0.tar.gz"
    sha256 "8ec258d9f7ece72ef91c81f4edb45a2db064c16844b6afac90c575893beaa391"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackagesc101cea53440a882f1d9772e128d205482df0005f9425166dccbb5513953e43aboto3-1.35.79.tar.gz"
    sha256 "1fa26217cd33ded82e55aed4460cd55f7223fa647916aa0d3c5d6828e6ec7135"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages154fff271a347a3aaa24b41f4893a3f92a8ebfbe26cd96a5b3daaa15995a815bbotocore-1.35.79.tar.gz"
    sha256 "245bfdda1b1508539ddd1819c67a8a2cc81780adf0715d3de418d64c4247f346"
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
    url "https:files.pythonhosted.orgpackages10db58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "mpmath" do
    url "https:files.pythonhosted.orgpackagese047dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackagesfd1d06475e1cd5264c0b870ea2cc6fdb3e37177c1e565c43f56ff17a10e3937fnetworkx-3.4.2.tar.gz"
    sha256 "307c3669428c5362aab27c8a1260aa8f47c4e91d3891f48be0141738d8d053e1"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages450f27908242621b14e649a84e62b133de45f84c255eecb350ab02979844a788pydantic-2.10.3.tar.gz"
    sha256 "cb5ac360ce894ceacd69c403187900a02c4b20b693a9dd1d643e1effab9eadf9"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesa69f7de1f19b6aea45aeb441838782d68352e71bfa98ee6fa048d5041991b33epydantic_core-2.27.1.tar.gz"
    sha256 "62a763352879b84aa31058fc931884055fd75089cccbd9d58bb6afd01141b235"
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
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages0180cce854d0921ff2f0a9fa831ba3ad3c65cee3a46711addf39a2af52df2cfdrpds_py-0.22.3.tar.gz"
    sha256 "e32fee8ab45d3c2db6da19a5323bc3362237c8b653c70194414b892fd06a080d"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesc00a1cdbabf9edd0ea7747efdf6c9ab4e7061b085aa7f9bfc36bb1601563b069s3transfer-0.10.4.tar.gz"
    sha256 "29edc09801743c21eb5ecbc617a152df41d3c287f67b615f73e5f750583666a7"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sympy" do
    url "https:files.pythonhosted.orgpackages118a5a7fd6284fa8caac23a26c9ddf9c30485a48169344b4bd3b0f02fef1890fsympy-1.13.3.tar.gz"
    sha256 "b27fd2c6530e0ab39e275fc9b683895367e51d5da91baa8d3d64db2565fec4d9"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.yml").write <<~YAML
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
    YAML
    system bin"cfn-lint", "test.yml"
  end
end