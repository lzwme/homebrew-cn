class Cfripper < Formula
  include Language::Python::Virtualenv

  desc "Library and CLI tool to analyse CloudFormation templates for security issues"
  homepage "https://github.com/Skyscanner/cfripper"
  url "https://files.pythonhosted.org/packages/ba/a5/36ce53ca9b14b2a10e73a8c5f2cff2adaa40b04c3e032b263d144009b3bf/cfripper-1.15.0.tar.gz"
  sha256 "718ce7261705f47fc968c6dfd805f40a1e7854b209ae530b07bca23464f26d00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81e35b727560de8b78a39ee75959f92f782c05ba9c81933d2cb7d5fb6dbbb386"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d6adeb94dfc1469fa8f45b2b4c40df1a17e96c913dffe8d981172927be1eee0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1917d0895e6b85d4cd3b443d965014efe8f4ecee55619a021d64a78e1478ceaf"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dc5418b57c29936be9ef5caa2edab16620cdd3cd01289728a889198c2c47144"
    sha256 cellar: :any_skip_relocation, ventura:        "ec5bcce79e2eb3c7b912eba94d66daaf10c6e11e7608e45769e2f02eec03b962"
    sha256 cellar: :any_skip_relocation, monterey:       "d45bd0575882073f206f27478736e7b2fa21fa825c7ce1bede11dc516ade10fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fce5ed256bd20846ac491b6c2af1bbda266d37f501f409dd0d14bbb4d355ce6d"
  end

  depends_on "python-click"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/6b/06/7e2ca443db1af4f3cb76d36eb9f20baf78688ddb095d473e733309a22bb2/boto3-1.29.3.tar.gz"
    sha256 "d038b19cbe29d488133351ee6eb36ee11a0934df8bcbc0892bbeb2c544a327a4"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/de/d1/6bbd2a3ade785ff5af9f46c0865c3e7e0f1e4d3c99e9530756ffda9cc1aa/botocore-1.32.3.tar.gz"
    sha256 "be622915db1dbf1d6d5ed907633471f9ed8f5399dd3cf333f9dc2b955cd3e80d"
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