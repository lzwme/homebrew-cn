class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https:github.comaws-cloudformationcfn-lint"
  url "https:files.pythonhosted.orgpackagesd003016ec2a5a37f7c8486773d7e889c7f4c9fe6b260515891930a0609122425cfn_lint-1.34.0.tar.gz"
  sha256 "c3f63ac641c005ee5c199c5cedc5b921b716af315096f3a74f2c80e002627a2c"
  license "MIT-0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "91d1daf79225d588c9ec2c0023699deac84202ff2805f0b78026036b3a43ec51"
    sha256 cellar: :any,                 arm64_sonoma:  "61f93b3bb4bebdd5ac54769d47dbf4a915ad1a7697e6a4e1459cc7d5128e4ef7"
    sha256 cellar: :any,                 arm64_ventura: "f91df1ef1917ae95916e5da1b6daef4a88ab1ea38c93b4340c5755a57ce8e9c8"
    sha256 cellar: :any,                 sonoma:        "e7b7f014d1cc498e486093d91ce25d5219b68015a025f36d5cab31449cd04331"
    sha256 cellar: :any,                 ventura:       "8e16ed4124dd45e0274d74e9c5465694a4f799f811c5923e953e04cec82dfb33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0449832a0248dfc345aaa551c7ef4d1f3866d481a3926c96241b776affe24ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c6214ef0da8678a44197c12000cb0bc6a7771fd639439b71deab2b933065a51"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "aws-sam-translator" do
    url "https:files.pythonhosted.orgpackages13013a9a3fea6ed942239f22c4fa9b3cd9d8b69545607f257fbb47d28d115ddeaws_sam_translator-1.97.0.tar.gz"
    sha256 "6f7ec94de0a9b220dd1f1a0bf7e2df95dd44a85592301ee830744da2f209b7e6"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages395d6b1ca20ba4da350799509a69f2d295ae11d5ec08a98e82f74b5708a8180cboto3-1.37.34.tar.gz"
    sha256 "94ca07328474db3fa605eb99b011512caa73f7161740d365a1f00cfebfb6dd90"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackagesca609ec251a0e2d3994f3eac8bd9741576757c3aad189abbdec8fab6011f5a1abotocore-1.37.34.tar.gz"
    sha256 "2909b6dbf9c90347c71a6fa0364acee522d6a7664f13d6f7996c9dd1b1f46fac"
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
    url "https:files.pythonhosted.orgpackages102eca897f093ee6c5f3b0bee123ee4465c50e75431c3d5b6a3b44a47134e891pydantic-2.11.3.tar.gz"
    sha256 "7471657138c16adad9322fe3070c0116dd6c3ad8d649300e3cbdfe91f4db4ec3"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages1719ed6a078a5287aea7922de6841ef4c06157931622c89c2a47940837b5eecdpydantic_core-2.33.1.tar.gz"
    sha256 "bcc9c6fdb0ced789245b02b7d6603e17d1563064ddcfc36f046b61c0c05dd9df"
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
    url "https:files.pythonhosted.orgpackages2fdb98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages0bb352b213298a0ba7097c7ea96bee95e1947aa84cc816d48cebb539770cdf41rpds_py-0.24.0.tar.gz"
    sha256 "772cc1b2cd963e7e17e6cc55fe0371fb9c704d63e44cacec7b9b7f523b78919e"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages0fecaa1a215e5c126fe5decbee2e107468f51d9ce190b9763cb649f76bb45938s3transfer-0.11.4.tar.gz"
    sha256 "559f161658e1cf0a911f45940552c696735f5c74e64362e515f333ebed87d679"
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
    url "https:files.pythonhosted.orgpackagesf63723083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackages825ce6082df02e215b846b4b8c0b887a64d7d08ffaba30605502639d44c06b82typing_inspection-0.4.0.tar.gz"
    sha256 "9765c87de36671694a67904bf2c96e395be9c6439bb6c87b5142569dcdd65122"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cfn-lint --version")

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