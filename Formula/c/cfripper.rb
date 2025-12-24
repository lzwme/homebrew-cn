class Cfripper < Formula
  include Language::Python::Virtualenv

  desc "Library and CLI tool to analyse CloudFormation templates for security issues"
  homepage "https://cfripper.readthedocs.io"
  url "https://files.pythonhosted.org/packages/7d/98/6caba75675f70f42ecc226b6d5c160a98b6631f1009b407c282a787592fa/cfripper-1.19.1.tar.gz"
  sha256 "89578fdb7c83ea5d6bf328b1b014352f8a57059e7f36730fbc94a17a78379bfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ebf401524e9da9307f2b168eeba1934531eb1771b7a6af639809cc0643dbafe3"
    sha256 cellar: :any,                 arm64_sequoia: "fad654926119779dc98f19efd5ce3ec197ea63d38eb3d6abc1c654d1e6b93c55"
    sha256 cellar: :any,                 arm64_sonoma:  "5cf38b852743e5fd9d2938f061a28d046eb56a5c63e366ad983a3fc9f25b9ce8"
    sha256 cellar: :any,                 sonoma:        "fc3032fbbc7a725e9df80d0e6aed6cf7d987d961258de71bdbde40418156152a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f69ab2d657ff36b1fb560a56cf78a3e17dc0a3fabbaa9af94f76e66a78e502fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdb9851611e9cec913a4fff11ae50e55bb88b9b50071fbc8d6d9d35b89d5a15a"
  end

  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "pydantic"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/a0/82/66f1cd7ce283ab717c96700899e9d128927abda236bd96019747f45ad53d/boto3-1.42.15.tar.gz"
    sha256 "d673c9b6bb9e293e028e354de6701351f1881e3fbeb25d739dd33c4940a30929"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/be/ae/80c8689a846066156117ad76cdfca52003fb9d3f1f5de38535f4aba9bf6c/botocore-1.42.15.tar.gz"
    sha256 "504c548aa333728c99a692908d3e6acb718983585ad7a836d2fab9604518a636"
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
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pycfmodel" do
    url "https://files.pythonhosted.org/packages/37/12/32eb36667d1af57fb07cd25233c94f83760a5e1ff9e162107687bac666a1/pycfmodel-1.2.0.tar.gz"
    sha256 "42373cdaeaa1f55e0b82b23af724ce3cc5bc1fb5ff91700d94713d80386d5afe"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/2f/24/91c037f47e434172c2112d65c00c84d475a6715425e3315ba2cbb7a87e66/pydash-8.0.5.tar.gz"
    sha256 "7cc44ebfe5d362f4f5f06c74c8684143c5ac481376b059ff02570705523f9e2e"
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
    url "https://files.pythonhosted.org/packages/1e/24/a2a2ed9addd907787d7aa0355ba36a6cadf1768b934c652ea78acbd59dcd/urllib3-2.6.2.tar.gz"
    sha256 "016f9c98bb7e98085cb2b4b17b87d2c702975664e4f060c6532e64d1c1a5e797"
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