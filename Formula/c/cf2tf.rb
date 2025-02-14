class Cf2tf < Formula
  include Language::Python::Virtualenv

  desc "Cloudformation templates to Terraform HCL converter"
  homepage "https:github.comDontShaveTheYakcf2tf"
  url "https:files.pythonhosted.orgpackagesbac4cd7ddd8c942b71a2db200c42e9ed8c336111db94e2399d3903db6e77eef2cf2tf-0.9.1.tar.gz"
  sha256 "cc334b8373412745b3790bed9db71e02d4c41e274e1774b3b23626bdd78bf357"
  license "GPL-3.0-only"
  head "https:github.comDontShaveTheYakcf2tf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a7f3e07e109017529ba8ecedc9b33222576154a17cf777e4eff48b1feedee56f"
    sha256 cellar: :any,                 arm64_sonoma:  "7d0f05caa33598ec57622a5b62de2edddc863d73cef3b825eb6e8d246993529e"
    sha256 cellar: :any,                 arm64_ventura: "81b665a7756eb719629819634b44a24989cfcc62e0d7c04578eddbfdd940a3d0"
    sha256 cellar: :any,                 sonoma:        "36d96d9198905f6ca8c46b79f6167be43be6ec405bbde1f2d0fab2cf713af9e6"
    sha256 cellar: :any,                 ventura:       "05763dae150a03507944088c2b638ec92d8e16cce8f3f7d39de05f651cee5044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bcc59e926687dbdb01fb502547651bc46ff42657513ebdb726db020fc7dce30"
  end

  depends_on "cmake" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "cfn-flip" do
    url "https:files.pythonhosted.orgpackagesca758eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-log" do
    url "https:files.pythonhosted.orgpackages3232228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages729463b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320agitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesc08937df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "iniconfig" do
    url "https:files.pythonhosted.orgpackagesd74bcbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages962d02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackages053530e0d83068951d90a01852cb1cef56e5d8a09d20c7f511634cc2f7e0372apytest-8.3.4.tar.gz"
    sha256 "965370d062bce11e73868e0335abac31b4d3de0e82f4007408d242b4f8610761"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rapidfuzz" do
    url "https:files.pythonhosted.orgpackagesc9dfc300ead8c2962f54ad87872e6372a6836f0181a7f20b433c987bd106bfcerapidfuzz-3.12.1.tar.gz"
    sha256 "6a98bbca18b4a37adddf2d8201856441c26e9c981d8895491b5bc857b5f780eb"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages44cda040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3bsmmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "thefuzz" do
    url "https:files.pythonhosted.orgpackages814bd3eb25831590d6d7d38c2f2e3561d3ba41d490dc89cd91d9e65e7c812508thefuzz-0.22.1.tar.gz"
    sha256 "7138039a7ecf540da323792d8592ef9902b1d79eb78c147d4f20664de79f3680"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"cf2tf", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath"test.yaml").write <<~YAML
      AWSTemplateFormatVersion: '2010-09-09'
      Description: 'Hello World S3 Bucket CloudFormation Stack'
      Resources:
        HelloWorldS3Bucket:
          Type: 'AWS::S3::Bucket'
          Properties:
            BucketName: hello-world-s3-bucket
            AccessControl: PublicRead
    YAML

    expected = <<~HCL
      resource "aws_s3_bucket" "hello_world_s3_bucket" {
        bucket = "hello-world-s3-bucket"
        acl = "public-read"
      }
    HCL

    system bin"cf2tf", "test.yaml", "-o", testpath
    assert_match expected, (testpath"resource.tf").read

    assert_match version.to_s, shell_output("#{bin}cf2tf --version")
  end
end