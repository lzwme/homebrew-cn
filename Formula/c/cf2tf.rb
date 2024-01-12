class Cf2tf < Formula
  include Language::Python::Virtualenv

  desc "Cloudformation templates to Terraform HCL converter"
  homepage "https:github.comDontShaveTheYakcf2tf"
  url "https:files.pythonhosted.orgpackagesea3fc1861f5f8f6c8430c34b3cac46aa7c8723a403a5bffec448a8acf1cfd23ccf2tf-0.6.2.tar.gz"
  sha256 "7b2ec09154279d247a3dada67b82c571143805ff7e9bb6d7ebada8fa6908a773"
  license "GPL-3.0-only"
  revision 1
  head "https:github.comDontShaveTheYakcf2tf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1110aaec54e0f607c615fb3efdc03407b40e968038454c15b261736cdf2c93ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1d5e2b1b4089b61b2931d537404b9e27a41666e78121dedb77828559a8d44c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "440ef00648677632d30ed0070f899985a6e12ea3bd86df21341cf209d903d499"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9efa146e76217fe1fe51dcf3816b630a7aaeac2e256c658880603ea0571b7ea"
    sha256 cellar: :any_skip_relocation, ventura:        "7536a702d64378a2c441727ef496de824de8a9395a70582c13e01fdf6b4bf8a8"
    sha256 cellar: :any_skip_relocation, monterey:       "33fdb703a0b0d1aee85c476b7413155b20a01560ec31c2247403c6a553046d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf5fe51a79c1cd58c8c5d429e9edc3d092f3223e5819be3fac43220564409278"
  end

  depends_on "cmake" => :build
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "six"

  resource "cfn-flip" do
    url "https:files.pythonhosted.orgpackagesca758eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https:files.pythonhosted.orgpackagese5c26e3a26945a7ff7cf2854b8825026cf3f22ac8e18285bc11b6b1ceeb8dc3fGitPython-3.1.41.tar.gz"
    sha256 "ed66e624884f76df22c8e16066d567aaa5a37d5b5fa19db2c6df6f7156db9048"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "iniconfig" do
    url "https:files.pythonhosted.orgpackagesd74bcbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages365104defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackages801f9d8e98e4133ffb16c90f3b405c43e38d3abb715bb5d7a63a5a684f7e46a3pytest-7.4.4.tar.gz"
    sha256 "2cf0005922c6ace4a3e2ec8b4080eb0d9753fdc93107415332f50ce9e7994280"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "rapidfuzz" do
    url "https:files.pythonhosted.orgpackagesd4f4039e35e99c967100d73616ec08d4c02325f67e0d5c32a6d5a49a7f620942rapidfuzz-3.6.1.tar.gz"
    sha256 "35660bee3ce1204872574fa041c7ad7ec5175b3053a4cb6e181463fc07013de7"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "thefuzz" do
    url "https:files.pythonhosted.orgpackages75e19859c094bb47674c2e9b3f51518f488d665941422352f9f7880b72bc86f4thefuzz-0.20.0.tar.gz"
    sha256 "a25e49786b1c4603c7fc6e2d69e6bc660982a2919698b536ff8354e0631cc40d"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def python
    which("python3.12")
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