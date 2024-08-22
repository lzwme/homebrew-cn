class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https:github.comokiganawscurl"
  url "https:files.pythonhosted.orgpackages2daf0a58eab617da80ae724b44b93acafdcac8f55a3bfc741499657aedb8d128awscurl-0.34.tar.gz"
  sha256 "648af1acf5f2f4ecfa25391c65c18be62340e2c2715a6a00efa1444211a2b2a0"
  license "MIT"
  head "https:github.comokiganawscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a5e1ba55df4cba1992cd88b264b275a522506b9c6f21aa1897fc3a5ba09cca2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a5e1ba55df4cba1992cd88b264b275a522506b9c6f21aa1897fc3a5ba09cca2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a5e1ba55df4cba1992cd88b264b275a522506b9c6f21aa1897fc3a5ba09cca2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a5e1ba55df4cba1992cd88b264b275a522506b9c6f21aa1897fc3a5ba09cca2"
    sha256 cellar: :any_skip_relocation, ventura:        "4a5e1ba55df4cba1992cd88b264b275a522506b9c6f21aa1897fc3a5ba09cca2"
    sha256 cellar: :any_skip_relocation, monterey:       "4a5e1ba55df4cba1992cd88b264b275a522506b9c6f21aa1897fc3a5ba09cca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94bbd1e888c869412dd5ddc2bc8e124b85270d5e283c5a976e036cbca5244f1d"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages30af51b89a099da1900ad6d760d9b3f88a668309b4b480158e777161c5e63e29botocore-1.35.2.tar.gz"
    sha256 "96c8eb6f0baed623a1b57ca9f24cb21d5508872cf0dfebb55527a85b6dbc76ba"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages708a73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783eConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "configparser" do
    url "https:files.pythonhosted.orgpackagesa52ea8d83652990ecb5df54680baa0c53d182051d9e164a25baa0582363841d1configparser-7.1.0.tar.gz"
    sha256 "eb82646c892dbdf773dae19c633044d163c3129971ae09b49410a303b8e0a5f7"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    assert_match "Curl", shell_output("#{bin}awscurl --help")

    assert_match "The AWS Access Key Id you provided does not exist in our records.",
      shell_output("#{bin}awscurl --service s3 https:homebrew-test-non-existent-bucket.s3.amazonaws.com")
  end
end