class Cfripper < Formula
  include Language::Python::Virtualenv

  desc "Library and CLI tool to analyse CloudFormation templates for security issues"
  homepage "https://cfripper.readthedocs.io"
  url "https://files.pythonhosted.org/packages/46/09/854392044c304f5cf3fae08b809e10f44e50068f241fcbeb594aa990e2b7/cfripper-1.15.2.tar.gz"
  sha256 "948f5e2d7f69a620c4472471cb2b43d3aff19d38bae0f13cf532efa08b47a498"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1531e3bdf0ae734ba4a35a5bd47c5a30d1e82134812e9f2b0518d926e4dfccd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "622c27c54ddb278cf7ed969468c2cd8eccd7f7cfdec28b7814944fad368c6362"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00ba5c731f245db8406f081aa8a40036d5fb712997c89d5b5519434938a3c1a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "10a993f6fd6158e8ea6b3f36c943b7a42164ffdc1440f712d9be7d0a6797bb3f"
    sha256 cellar: :any_skip_relocation, ventura:        "59efb7a2e9e759a9f39780b01d90d048e4c44fb67b6834a7de8d2a154e422c9a"
    sha256 cellar: :any_skip_relocation, monterey:       "7021c22a2d604d3bd31256d5f9716ff956dfc63cecd246e311d2d223084ba87e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c8eb9bd87d85db0b9a88b5eae19f3384ff19afd7fd436527292f20374c67665"
  end

  depends_on "python-click"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/99/1e/0dfade9ee87863d2cf363d086fab6885491d3111a45ca976d2e1f785bc5b/boto3-1.33.7.tar.gz"
    sha256 "eed0f7df91066b6ac63a53d16459ac082458d57061bedf766135d9e1c2b75a6b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/77/82/ccd0b8fae17f05d9db896981bc084f2e913b672e99f16aea631c8ff9d008/botocore-1.33.7.tar.gz"
    sha256 "b2299bc13bb8c0928edc98bf4594deb14cba2357536120f63772027a16ce7374"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "pycfmodel" do
    url "https://files.pythonhosted.org/packages/ef/b0/0844b357c0d47ed9e83748107cd1dbccfc49d52396be48f52132893c30d7/pycfmodel-0.21.1.tar.gz"
    sha256 "4429f8d623c35324dd1b04dfbc36607ade1743f020a02fac6d387096ef2c828f"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/51/cd/721eb771f3f09f60de0807e240c3acf44c38828d0ced869fe8df7e79801b/pydantic-1.10.13.tar.gz"
    sha256 "32c8b48dcd3b2ac4e78b0ba4af3a2c2eb6048cb75202f0ea7b34feb740efc340"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/98/1c/b07ca0ab2f7d5e4df0eadb95337776406ea30ec53edfdbf21a1ce8a62230/pydash-7.0.6.tar.gz"
    sha256 "7d9df7e9f36f2bbb08316b609480e7c6468185473a21bdd8e65dda7915565a26"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/5f/cc/7e3b8305e22d7dcb383d4e1a30126cfac3d54aea2bbd2dfd147e2eff4988/s3transfer-0.8.2.tar.gz"
    sha256 "368ac6876a9e9ed91f6bc86581e319be08188dc60d50e0d56308ed5765446283"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.json").write <<~EOS
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
    EOS

    output = shell_output("#{bin}/cfripper #{testpath}/test.json --format txt 2>&1")
    assert_match "no AWS Account ID was found in the config.", output
    assert_match "Valid: True", output

    assert_match version.to_s, shell_output("#{bin}/cfripper --version")
  end
end