class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https:github.comaws-cloudformationcfn-lint"
  url "https:files.pythonhosted.orgpackages6d0e6a65ee50fdc718a7f2a99442f034f1d5d7cd37279bfc7a2d8177d66da7ffcfn_lint-1.33.2.tar.gz"
  sha256 "46336435eb39cd39b50809ee1c88e1c74c5312e37268af791b691011e0a851fa"
  license "MIT-0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "836324af50cdbfe1bb3400db0da04c6e2d25e89540818c6defcfe36c6f40335d"
    sha256 cellar: :any,                 arm64_sonoma:  "00d11a842aa163192c204614e909d7d983f4dc36ecaf6c2a65fc1a5c710f45ba"
    sha256 cellar: :any,                 arm64_ventura: "fbaf1c25337995c10d0c05ab3b2996fc3052d827be8fd7e1250ca5eec4d2eadf"
    sha256 cellar: :any,                 sonoma:        "c91665057f303f4cb7c478e185a9c9f1ccfbbf2e93c854b6e5c33a69b56e4f44"
    sha256 cellar: :any,                 ventura:       "5ffbcfd8c61693a32f5c2b7456f6a44cb0601075474e00e2dffdc6261cfcdf31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cecaadc8655eb43abf558588172059e89536c0664e44cc836280f3fcc6074ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28af288fe131d03f76ef284a99d3f238f46b8a8d96422c999ff8cf3e81e7dbe9"
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
    url "https:files.pythonhosted.orgpackages567abe6dfbe66f3a04434240edbb5425c0756f848af40c52194109afc0d265e9boto3-1.37.32.tar.gz"
    sha256 "bc08c95a88ffeb51d78d25cb8bd72593b8cce1d8fdcc650030aff98c15437d04"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages8f68407e8a712694eab28ca95ca2f9135d66e92975a54a37dda1aeefd26f8cd5botocore-1.37.32.tar.gz"
    sha256 "3e5d097690b3423adeefdf257384e964d0ba7f9575d77bf3f8998273b92ef700"
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