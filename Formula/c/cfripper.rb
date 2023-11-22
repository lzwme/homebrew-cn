class Cfripper < Formula
  include Language::Python::Virtualenv

  desc "Library and CLI tool to analyse CloudFormation templates for security issues"
  homepage "https://cfripper.readthedocs.io"
  url "https://files.pythonhosted.org/packages/51/93/e375c84b0bdac3e718bebe99c4c91a5946200aac73fe166fca006a7b2125/cfripper-1.15.1.tar.gz"
  sha256 "3a7b92daa036e4ed14bf2b01b0d14f76a7b71d664bfd572ee35a4eb96ca92bf8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6e7e06335b8665b3137ac5dd722d67e21cbd7787e9aa404e262b752a1495a74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bf398fbe660b3ba2b596b9e23cd50694f523c0cd5cbd5cbf234233a19295980"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ae0d9141cb2e80581ab6237b98774f50b3c1389dabb73e70930a87e7687b054"
    sha256 cellar: :any_skip_relocation, sonoma:         "192c8b38219dca35861becf45221acafb4715a7b0b84163a72a10f9328071731"
    sha256 cellar: :any_skip_relocation, ventura:        "d4a493fd40834f03a97562fa0896f107acebb2581d25a18078a6205902080d03"
    sha256 cellar: :any_skip_relocation, monterey:       "931ef40b566fae134bb43c751f6f3bf9c43dcc12fb26c3ed6519e8eea715b6f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0206adea625e611debf235a7c1589d1d35cf2d8c31981df2838c4c7cae41ea4e"
  end

  depends_on "python-click"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/8d/5f/4ee13ee77641c98032fcddb51456a26976f69365fdc3c6c9e699970b9e99/boto3-1.29.4.tar.gz"
    sha256 "ca9b04fc2c75990c2be84c43b9d6edecce828960fc27e07ab29036587a1ca635"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/10/6f/e7fe287501ae0bb2732e0752dde93c4a2ad1922953be16dd912acc2c26be/botocore-1.32.4.tar.gz"
    sha256 "6bfa75e28c9ad0321cefefa51b00ff233b16b2416f8b95229796263edba45a39"
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