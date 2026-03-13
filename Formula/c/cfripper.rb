class Cfripper < Formula
  include Language::Python::Virtualenv

  desc "Library and CLI tool to analyse CloudFormation templates for security issues"
  homepage "https://cfripper.readthedocs.io"
  url "https://files.pythonhosted.org/packages/98/86/7133429484d3be79e696ca73db97f9888cf3e4276681871fa29ee8f10e68/cfripper-1.20.0.tar.gz"
  sha256 "c30f9bed6839425971b64c11bda123a87b58915bf57e4b7ffef05a5ee6a257ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "773e920a4b0f84d09468edc95c2ddf5fb898ab17d9133c0d624c2608e1995aab"
    sha256 cellar: :any,                 arm64_sequoia: "c2854a9a2b6d4162ef34e7278742b2ac54dc0b7fc15c46eec7e5fc0ad5dffece"
    sha256 cellar: :any,                 arm64_sonoma:  "01b954b597eb263e19c56fd3838d97844b48d3503a747607264fc7541a5f9785"
    sha256 cellar: :any,                 sonoma:        "0d0ce2838c9e6d64915905c7fb2b0a022c044c4706cbafb603f650226735cc76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffbaac19e7fc4744efafae2c65af7e88ccecbb8b6390185c87376d8225a6bc80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49465a7a844221b43c6695a17418337f64c0fcc9e7777b30acb4c67b9c9f6b17"
  end

  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "pydantic"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/0a/2e/67206daa5acb6053157ae5241421713a84ed6015d33d0781985bd5558898/boto3-1.42.66.tar.gz"
    sha256 "3bec5300fb2429c3be8e8961fdb1f11e85195922c8a980022332c20af05616d5"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/77/ef/1c8f89da69b0c3742120e19a6ea72ec46ac0596294466924fdd4cf0f36bb/botocore-1.42.66.tar.gz"
    sha256 "39756a21142b646de552d798dde2105759b0b8fa0d881a34c26d15bd4c9448fa"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
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
    url "https://files.pythonhosted.org/packages/0e/29/e486b2961a534fe5175b27d5811933380cf51908caaa97edac0a75b9fb0a/pycfmodel-2.0.1.tar.gz"
    sha256 "dbe50a37c261b5ead6dc2252f914dd795f5ff9ac43d5e0c1b61d2d462183b8c5"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/75/c1/1c55272f49d761cec38ddb80be9817935b9c91ebd6a8988e10f532868d56/pydash-8.0.6.tar.gz"
    sha256 "b2821547e9723f69cf3a986be4db64de41730be149b2641947ecd12e1e11025a"
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
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
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