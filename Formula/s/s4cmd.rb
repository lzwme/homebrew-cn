class S4cmd < Formula
  include Language::Python::Virtualenv

  desc "Super S3 command-line tool"
  homepage "https://github.com/bloomreach/s4cmd"
  url "https://files.pythonhosted.org/packages/42/b4/0061f4930958cd790098738659c1c39f8feaf688e698142435eedaa4ae34/s4cmd-2.1.0.tar.gz"
  sha256 "42566058a74d3e1e553351966efaaffa08e4b6ac28a19e72a51be21151ea9534"
  license "Apache-2.0"
  revision 8
  head "https://github.com/bloomreach/s4cmd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b8bef2d5ea5b7e614daac89dbfdef484bb294f88fc5af9c38864d81c640cb315"
  end

  depends_on "python@3.14"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/2a/c4/c68d22d91482898f1294dab7541ad83f8bcf9df83107e6d8436d6e9dbf01/boto3-1.43.107.tar.gz"
    sha256 "c4e0f1a0295cbb7103f2950128cf88463c076d220080a7d0f127cf834969fc3a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/4d/22/3aed44a1e0b9820485124a9ad25e9bccd5539c547ef12827547c3cbeb25f/botocore-1.43.107.tar.gz"
    sha256 "4a37fa072a00280c746313532d19b00e2dc53f1993222601df104d71d548d5b6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/ed/fa23d28713004418bbf2407127f80f385bfb0bf4e677bef02c25c27b00ee/pytz-2026.4.tar.gz"
    sha256 "464303645bafafd72418898368b2429458f709cf1eb6a15372fbcc396b64da63"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Unable to locate credentials", shell_output("#{bin}/s4cmd ls s3://brew-test 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/s4cmd --version")
  end
end