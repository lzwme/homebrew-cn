class Cfripper < Formula
  include Language::Python::Virtualenv

  desc "Library and CLI tool to analyse CloudFormation templates for security issues"
  homepage "https://cfripper.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/62/5a/28072c10707f99253b292e9a9de7b9e2a2b4da740052e1a3247fbac9a6eb/cfripper-1.14.0.tar.gz"
  sha256 "e08237f45dc5e2b8ad7f71acfdb3525c0c5317e69a9392adc9bdcea8cfac69c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f170c89d796f67c36ed21a1815da90861132b7e131f764146496549b4c53151"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3493102896d06a16e00bde9120f9d3f15d7f78fc318d970bb38eb72910e370e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3912e468b18944d06a637467bcf9300a958db48ade83ffeadaca654da8e29a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "89aaf0e098a7911b509672d5d768f3077f35e5f15c592a233bb90f1e981be57e"
    sha256 cellar: :any_skip_relocation, ventura:        "738e37c6de2cafe52b68161df239c4df5f5b23a0aa9401f13b40b646006a758a"
    sha256 cellar: :any_skip_relocation, monterey:       "9e35dd2f18e52b9b1ae1bb7372ad34d6cde00dc46cbbc87b9a2cd44b9b5bb860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edcd7a813e3e845b4d8aa16558d4d80ef769fa273037249135ff38f1b1e1e3d9"
  end

  depends_on "python-click"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/70/f7/da69e173dd5663775f114fad3827dcc49537e232e36266463ff70529f1a4/boto3-1.28.78.tar.gz"
    sha256 "aa970b1571321846543a6e615848352fe7621f1cb96b4454e919421924af95f7"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/84/a9/9c2752aa24c050323c37a9d2af6dec348889825b51db07fb7f1bb792e307/botocore-1.31.78.tar.gz"
    sha256 "320c70bc412157813c2cf60217a592b4b345f8e97e4bf3b1ce49b6be69ed8965"
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
    url "https://files.pythonhosted.org/packages/f2/72/0058257bbbc2c6cc3b92a3f3351bf84bf75bc24130d71801227b20531450/pycfmodel-0.21.0.tar.gz"
    sha256 "0a4253f154f580b9d7465c909ab1a4f2a670adc16e86fabe215a40c66256805d"
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
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
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