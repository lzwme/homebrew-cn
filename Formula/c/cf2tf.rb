class Cf2tf < Formula
  include Language::Python::Virtualenv

  desc "Cloudformation templates to Terraform HCL converter"
  homepage "https:github.comDontShaveTheYakcf2tf"
  url "https:files.pythonhosted.orgpackages520094c12acc1ed644df1c3ee658068929c33863fccfdd2f8ab9236d58eb4496cf2tf-0.8.0.tar.gz"
  sha256 "f36bbf5abacdf70baeb12529a7ae4ba1c5f748112c240bef4a5ed0e0e654f44c"
  license "GPL-3.0-only"
  revision 2
  head "https:github.comDontShaveTheYakcf2tf.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "fdf7e3468b13c630f1800649353a4ed8b78ce1c595b9acc748e2d63bbca67c84"
    sha256 cellar: :any,                 arm64_sonoma:  "62f2649d42fe4e42597d6f8135aa3f5cc851d59d477240724c034286ffdb211d"
    sha256 cellar: :any,                 arm64_ventura: "2f4439a21605763fd2e9fe7d8c283d5d13b467dc060f409673d6fd5b8e0aa942"
    sha256 cellar: :any,                 sonoma:        "bdd998c6cf8fdc351cb65918f8eb45b72da43026dddd3b54dc5a18c93a71e2a6"
    sha256 cellar: :any,                 ventura:       "97e99e2dc3b98b3da83c1a881385649be0cf326a06b1bf0967c2dea50641a163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bc8b1c28a76c27344d84ea60cd25611eea17143634864f2f54de5f2511c0cc7"
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
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-log" do
    url "https:files.pythonhosted.orgpackages3232228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages190dbbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8edgitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesb6a1106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
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
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages962d02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackages8b6c62bbd536103af674e227c41a8f3dcd022d591f6eed5facb5a0f31ee33bbcpytest-8.3.3.tar.gz"
    sha256 "70b98107bd648308a7952b06e6ca9a50bc660be218d53c257cc1fc94fda10181"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rapidfuzz" do
    url "https:files.pythonhosted.orgpackages8143ce16df67029b8e4f528fd1b3fbe5e9fcfc6fcc16823c66349260dd93750erapidfuzz-3.10.0.tar.gz"
    sha256 "6b62af27e65bb39276a66533655a2fa3c60a487b03935721c45b7809527979be"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "thefuzz" do
    url "https:files.pythonhosted.orgpackages814bd3eb25831590d6d7d38c2f2e3561d3ba41d490dc89cd91d9e65e7c812508thefuzz-0.22.1.tar.gz"
    sha256 "7138039a7ecf540da323792d8592ef9902b1d79eb78c147d4f20664de79f3680"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"cf2tf", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath"test.yaml").write <<~EOS
      AWSTemplateFormatVersion: '2010-09-09'
      Description: 'Hello World S3 Bucket CloudFormation Stack'
      Resources:
        HelloWorldS3Bucket:
          Type: 'AWS::S3::Bucket'
          Properties:
            BucketName: hello-world-s3-bucket
            AccessControl: PublicRead
    EOS

    expected = <<~EOS
      resource "aws_s3_bucket" "hello_world_s3_bucket" {
        bucket = "hello-world-s3-bucket"
        acl = "public-read"
      }
    EOS

    system bin"cf2tf", "test.yaml", "-o", testpath
    assert_match expected, (testpath"resource.tf").read

    assert_match version.to_s, shell_output("#{bin}cf2tf --version")
  end
end