class S4cmd < Formula
  include Language::Python::Virtualenv

  desc "Super S3 command-line tool"
  homepage "https:github.combloomreachs4cmd"
  url "https:files.pythonhosted.orgpackages42b40061f4930958cd790098738659c1c39f8feaf688e698142435eedaa4ae34s4cmd-2.1.0.tar.gz"
  sha256 "42566058a74d3e1e553351966efaaffa08e4b6ac28a19e72a51be21151ea9534"
  license "Apache-2.0"
  revision 3
  head "https:github.combloomreachs4cmd.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "43d2483c9cb4dcbe9c834c42ba1b972a1d1702e03078513d9dc9baa76655fc9b"
  end

  depends_on "python@3.13"

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages808b31845869fb935b93d1f1a846d2a8e13dc91af4cf03ba701e2068c08b99afboto3-1.35.37.tar.gz"
    sha256 "470d981583885859fed2fd1c185eeb01cc03e60272d499bafe41b12625b158c8"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages57a4bc96ba621c869f723ce4cb4dadb53fdbb821d64ef1146f0749098ef342cfbotocore-1.35.37.tar.gz"
    sha256 "b2b4d29bafd95b698344f2f0577bb67064adbf1735d8a0e3c7473daa59c23ba6"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages3a313c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3fpytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesa0a8e0a98fd7bd874914f0608ef7c90ffde17e116aefad765021de0f012690a2s3transfer-0.10.3.tar.gz"
    sha256 "4f50ed74ab84d474ce614475e0b8d5047ff080810aac5d01ea25231cfc944b0c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Unable to locate credentials", shell_output("#{bin}s4cmd ls s3:brew-test 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}s4cmd --version")
  end
end