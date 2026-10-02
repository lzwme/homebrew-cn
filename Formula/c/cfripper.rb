class Cfripper < Formula
  include Language::Python::Virtualenv

  desc "Library and CLI tool to analyse CloudFormation templates for security issues"
  homepage "https://cfripper.readthedocs.io"
  url "https://files.pythonhosted.org/packages/ad/ab/cf03ff1c0e248e1a5de91b603a5dbba6855e6069670a390f139669f61e9c/cfripper-1.21.1.tar.gz"
  sha256 "e0f5f17e0869764d5ef6394a70898d9485c4d200b0b1e3b04e57e7c940bf9731"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c51c0fde2f84447070450c02e46c5087012b8c73afe7998141db94f64bff41c5"
    sha256 cellar: :any, arm64_tahoe:       "a3b774ad5ee37f0ec294dfc5a94b4de58832c290d9a8cb17cd89ae355f96c557"
    sha256 cellar: :any, arm64_sequoia:     "4d21f2193a45b5707450b0bd780a0e4e82e0a573663b2543ec5807577a0dc492"
    sha256 cellar: :any, arm64_linux:       "cd60e5ad6c5e22e83583abddd3f99614a7d227df954abddb008c4d40ea4ba540"
    sha256 cellar: :any, x86_64_linux:      "e90748b9cbba2d8d3d5a50e14ba600e6aaf16831f6de67e5406f769e6d330eb2"
  end

  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "pydantic"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/75/46/d8c87ada70a7647fb3d206c7f19eafca3580a0ae4c06d62da539a1ee1207/boto3-1.43.105.tar.gz"
    sha256 "e51260aed9cc1474778b5488bc6f97ad28f27a0a7002f4bbaaf8191aff1422ea"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2b/30/668f3c0533a440787e212cf56404cb6ec234ae8e6baf97fe17329d512d88/botocore-1.43.105.tar.gz"
    sha256 "afb3e7706b123ab069d1c34571ca1fdf82528a48425574fe4693df3d039d503f"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pycfmodel" do
    url "https://files.pythonhosted.org/packages/30/fd/ffe084171d58fa3e2f077cdf2a52402a7d7bb54c0ae4ea8be7b6f3b13faf/pycfmodel-2.1.3.tar.gz"
    sha256 "f73817033b6b7ce8d0ce29d9c1dd2cea0130836348818fe353c21cf986f8273c"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/ae/49/45cd795ce88bde203c7b4cfd7c911c9078b32582afa3b9af579824d8789d/pydash-8.1.0.tar.gz"
    sha256 "30914c3e9d377ea2cd0d3c0a4f252889b08392f730a5eb4d117e5b598cdf1d52"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
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

    generate_completions_from_executable(bin/"cfripper", shell_parameter_format: :click)
  end

  test do
    (testpath/"test.json").write <<~JSON
      {
        "AWSTemplateFormatVersion": "2010-09-09",
        "Resources": {
          "RootRole": {
            "Type": "AWS::IAM::Role",
            "Properties": {
              "AssumeRolePolicyDocument": {
                "Version": "2012-10-17",
                "Statement": [
                  {
                    "Effect": "Allow",
                    "Principal": {
                      "AWS": "arn:aws:iam::999999999:role/someuser@bla.com"
                    },
                    "Action": "sts:AssumeRole"
                  }
                ]
              },
              "Path": "/",
              "Policies": []
            }
          }
        }
      }
    JSON

    output = shell_output("#{bin}/cfripper #{testpath}/test.json --format txt 2>&1")
    assert_match "no AWS Account ID was found in the config.", output
    assert_match "Valid: True", output

    assert_match version.to_s, shell_output("#{bin}/cfripper --version")
  end
end