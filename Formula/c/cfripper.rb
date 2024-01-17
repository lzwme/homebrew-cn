class Cfripper < Formula
  include Language::Python::Virtualenv

  desc "Library and CLI tool to analyse CloudFormation templates for security issues"
  homepage "https://cfripper.readthedocs.io"
  url "https://files.pythonhosted.org/packages/8c/3e/5370821e6551771cb974950c22feb329fcb09205151f9f12822d2f9e696e/cfripper-1.15.3.tar.gz"
  sha256 "cbf0c0d42dfbb91eba292a79543ddc9ded7cf65f2beadcc845737b31304fb7c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03a964032e42370cd1929d66cf14490b2140cb68dc0560e995698988904b5ba7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "803f9f1c7ece274822ebaa909ecdade8b85f5b4d109d2951127009276684ddda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e11a62db16379fc07a4829284909b25a29c4511e38a4f466f44433361cd37172"
    sha256 cellar: :any_skip_relocation, sonoma:         "be0a0b0c49a3c5f5c86783ef39d2445eb5eb1aa6c38c9d2a2e7ddec540abee78"
    sha256 cellar: :any_skip_relocation, ventura:        "d866f57658e71663cc162ee22e10620bfeb12424aac8e312c8d450afd4745d96"
    sha256 cellar: :any_skip_relocation, monterey:       "54f8b4f2b0001aa9e6d6c7b893a7d832d8ef47b13112f257fbee24085da4f58c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44919b7bf64cf5f4eed40e953c930d83b13fab090d946a5d51e77b2cb6120bf3"
  end

  depends_on "python-click"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/4f/2e/ef7530d7e5d0576ca252fbdd99001ebbd94f3d7ffb8b4a496915d07fdddf/boto3-1.34.19.tar.gz"
    sha256 "95d2c2bde86a0934d4c461020c50fc1344b444f167654e215f1de549bc77fc0f"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/bc/d8/a31a6f55f2e438e6e3f19fc302a540ecf2c545684be5b7f5b875aca54892/botocore-1.34.19.tar.gz"
    sha256 "64352b2f05de5c6ab025c1d5232880c22775356dcc5a53d798a6f65db847e826"
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
    url "https://files.pythonhosted.org/packages/70/ad/ed2cada00e9403fd4eb5ffd199071caa825712cf609798ca9088b61d52c7/pycfmodel-0.21.2.tar.gz"
    sha256 "bb2ac910fde368cc470133fa3568a6aad55a87ac93ec9da9efa2cd4cff27262e"
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
    url "https://files.pythonhosted.org/packages/a0/b5/4c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40ba/s3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
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