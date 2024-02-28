class Cfripper < Formula
  include Language::Python::Virtualenv

  desc "Library and CLI tool to analyse CloudFormation templates for security issues"
  homepage "https://cfripper.readthedocs.io"
  url "https://files.pythonhosted.org/packages/86/e5/ae2e0ea2a459217e62ee38602241c38ebf8d3fd772cf884cc131f1baa97a/cfripper-1.15.5.tar.gz"
  sha256 "2b7f80dbb2a49e0568ab5bb876df37b49e959a7600e7eadef7afc0d7ba0fa7e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d1ea4f8d9a839e7efd36098dd2aee4fa8f2b6ed2a763e2a8e8beb6508fb3b19e"
    sha256 cellar: :any,                 arm64_ventura:  "c8dcb0a58f3f97b4dad5c9bcaa9ddc13bd51ecd852bc8edc084f25a098ae7d47"
    sha256 cellar: :any,                 arm64_monterey: "91d6d246b538f962e1109545beba45b3dc61b589f7c31a72a0f88a86385197bb"
    sha256 cellar: :any,                 sonoma:         "09e3c9bd873145a4e4b4e4d005c0d964c6a99bab2b888194700770c43a60159f"
    sha256 cellar: :any,                 ventura:        "f79b7e389a577325d5cc7351bad298f9a93fa27b1a6252be22a3b93e3ad3c5c8"
    sha256 cellar: :any,                 monterey:       "e2f64438e17d8741bc8541a4b57de1640e2f49626bd0a0ce9c6b2d09b51ff82a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1aad32e775b5ff764483cd8a6fbff8c59816f5390b5f176af23bb41e5e905d6"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/dc/d1/23a7ed157ca950a344b2ef814db01c175f970320c4bf1be364ca0c1afdd2/boto3-1.34.50.tar.gz"
    sha256 "290952be7899560039cb0042e8a2354f61a7dead0d0ca8bea6ba901930df0468"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/48/af/d038bd03233fe5c009fd67e8e1bfa6536c3b2ab91737cc629acbff464aa3/botocore-1.34.50.tar.gz"
    sha256 "33ab82cb96c4bb684f0dbafb071808e4817d83debc88b223e7d988256370c6d7"
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
    url "https://files.pythonhosted.org/packages/de/7a/bab391457bd63298866854a203d243e794f779d933b468211712c62f84fb/pycfmodel-0.22.0.tar.gz"
    sha256 "af07ea1dd2f8c4f5f187595e420ba841f30bce4e785ecab17d68248e64085a52"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/df/ab/67eda485b025e9253cce0eaede9b6158a08f62af7013a883b2c8775917b2/pydantic-1.10.14.tar.gz"
    sha256 "46f17b832fe27de7850896f3afee50ea682220dd218f7e9c88d436788419dca6"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/1a/15/dfb29b8c49e40b9bfd2482f0d81b49deeef8146cc528d21dd8e67751e945/pydash-7.0.7.tar.gz"
    sha256 "cc935d5ac72dd41fb4515bdf982e7c864c8b5eeea16caffbab1936b849aaa49a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/b5/4c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40ba/s3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/3a/0d26ce356c7465a19c9ea8814b960f8a36c3b0d07c323176620b7b483e44/typing_extensions-4.10.0.tar.gz"
    sha256 "b0abd7c89e8fb96f98db18d86106ff1d90ab692004eb746cf6eda2682f91b3cb"
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