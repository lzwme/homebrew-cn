class Cfripper < Formula
  include Language::Python::Virtualenv

  desc "Library and CLI tool to analyse CloudFormation templates for security issues"
  homepage "https://cfripper.readthedocs.io"
  url "https://files.pythonhosted.org/packages/3d/83/5c263793a35b0cc591806165876641ccae8252c1c8108d066128f5de3108/cfripper-1.15.7.tar.gz"
  sha256 "632160c24684ef2e8bd54332d93e133a8afed5455668af80801acc4e3cfecbc1"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "28cfdfb5a42b6af0e108533c46035556598d507d7b3fb4039ea5eb4cfcb609c2"
    sha256 cellar: :any,                 arm64_ventura:  "58c439c301cc57c3e8bf32746c4db87c28db0033de62bfe94909874f89deecc8"
    sha256 cellar: :any,                 arm64_monterey: "d51e060a00eaaeea1195e77c0a1584507270f621b6aea56903b5fcdaf0713cb1"
    sha256 cellar: :any,                 sonoma:         "9189a4983ae64daadbbac63ac1fb4ed3fc2ad08ca4d1390825b30b7177d349df"
    sha256 cellar: :any,                 ventura:        "b3a07d8ac4eeccc702ee5e87907c4f8f607ebadf7b05fad3e060d96a72b7946c"
    sha256 cellar: :any,                 monterey:       "fc14660d0aafad3270c49c15600b68f30bc45b67aecf22f54d506c4a3027a049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8770d9574bf2ecca53b7c4240a2678170757fe1ce14b4c4520b658cb5c07c4d"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/81/f5/0c7d1b745462d9fe0c2b4709dc6a4b1cbe399c02ad60b26ae2837714d455/boto3-1.34.128.tar.gz"
    sha256 "43a6e99f53a8d34b3b4dbe424dbcc6b894350dc41a85b0af7c7bc24a7ec2cead"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9e/c9/844ad5680d847d94adb97b22c30b938ddda86f8a815d439503d4ee545484/botocore-1.34.128.tar.gz"
    sha256 "8d8e03f7c8c080ecafda72036eb3b482d649f8417c90b5dca33b7c2c47adb0c9"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
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
    url "https://files.pythonhosted.org/packages/d4/19/0c70b1942b5b27caea8c9dd9bb932ed437f122f966eeba51a25ee1b0f85f/pycfmodel-1.0.0.tar.gz"
    sha256 "2caf7eb1b6a8582902f75aeadedae081dd34ed1bb14e47665bb5185564191996"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/0d/fc/ccd0e8910bc780f1a4e1ab15e97accbb1f214932e796cff3131f9a943967/pydantic-2.7.4.tar.gz"
    sha256 "0c84efd9548d545f63ac0060c1e4d39bb9b14db8b3c0652338aecc07b5adec52"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/02/d0/622cdfe12fb138d035636f854eb9dc414f7e19340be395799de87c1de6f6/pydantic_core-2.18.4.tar.gz"
    sha256 "ec3beeada09ff865c344ff3bc2f427f5e6c26401cc6113d77e372c3fdac73864"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/e8/90/4cc84d60b32f3f069817705eaf7e07f3bceff050b56132885b71303aff88/pydash-8.0.1.tar.gz"
    sha256 "a24619643d3c054bfd56a9ae1cb7bd00e9774eaf369d7bb8d62b3daa2462bdbd"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/ff/08/b6768d9f2da231c1396490e91471ffebb12b299a65cb369c27ec0e2a50c6/pyyaml-6.0.2rc1.tar.gz"
    sha256 "826fb4d5ac2c48b9d6e71423def2669d4646c93b6c13612a71b3ac7bb345304b"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/83/bc/fb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571/s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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