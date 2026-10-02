class Awslogs < Formula
  include Language::Python::Virtualenv

  desc "Simple command-line tool to read AWS CloudWatch logs"
  homepage "https://github.com/jorgebastida/awslogs"
  url "https://files.pythonhosted.org/packages/15/f5/8f3bd0f4a927b1fbb3a5e6a5b036f29e4263977fb167b301bc4a5f4db2b9/awslogs-0.15.0.tar.gz"
  sha256 "19f223bb1c0703cea0689d94b1d293006529095e6ab8971f6b52289a2e545dd5"
  license "BSD-3-Clause"
  revision 6
  head "https://github.com/jorgebastida/awslogs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e67ad8c2ab2354a24e309eb9e47c1c21bf12213ee1c1478376d60b7fae8005ab"
  end

  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/75/46/d8c87ada70a7647fb3d206c7f19eafca3580a0ae4c06d62da539a1ee1207/boto3-1.43.105.tar.gz"
    sha256 "e51260aed9cc1474778b5488bc6f97ad28f27a0a7002f4bbaaf8191aff1422ea"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2b/30/668f3c0533a440787e212cf56404cb6ec234ae8e6baf97fe17329d512d88/botocore-1.43.105.tar.gz"
    sha256 "afb3e7706b123ab069d1c34571ca1fdf82528a48425574fe4693df3d039d503f"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/46/79/cf31d7a93a8fdc6aa0fbb665be84426a8c5a557d9240b6239e9e11e35fc5/termcolor-3.3.0.tar.gz"
    sha256 "348871ca648ec6a9a983a13ab626c0acce02f515b9e1983332b17af7979521c5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awslogs --version")

    assert_match "You must specify a region", shell_output("#{bin}/awslogs groups 2>&1", 1)
  end
end