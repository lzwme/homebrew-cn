class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https:awsu.me"
  url "https:files.pythonhosted.orgpackagesd708264d5c0b1a2618c95f3a391e038830c18bcccce5f202b293acdb14b7ac63awsume-4.5.4.tar.gz"
  sha256 "4c1f6336e1f9e36b2144761345967f50f43128363892cc62325577201e133b1b"
  license "MIT"
  head "https:github.comtrek10incawsume.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "84aa955718f42b2fb6684efcdf9d73c00aae0d97704c9fa955bec671b15299b5"
    sha256 cellar: :any,                 arm64_ventura:  "57ec3efa9a742eaaf5d8a910aa24cc18e10c2531cdb384e36596c0eab890c992"
    sha256 cellar: :any,                 arm64_monterey: "43b0e1e0b8e913876d422619787cfcd02fd8697d9a367dd7be0d496721152310"
    sha256 cellar: :any,                 sonoma:         "0553ae46a87165c714f0906e3877ac637ecd7f58f56238fec080c9d22b0e227f"
    sha256 cellar: :any,                 ventura:        "7f8d4cb7f2ce640a009bef0e982384cae9ef033cbecac23763c21671f9b70f3a"
    sha256 cellar: :any,                 monterey:       "39f9b6599717ad85d77be2777ebc19da1af4c0fbe20f4ed48ba7bfc3c3cf7d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beb0ef6c8d3a7e7aa9c477dd723d10102ca3f5b942a17bb7cd821ff8e1d1f233"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  uses_from_macos "sqlite"

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages5fb61e45c3a145304c3feaf48959c6a46efe9a256eec4d417a445b0d9827d20cboto3-1.34.14.tar.gz"
    sha256 "5c1bb487c68120aae236354d81b8a1a55d0aa3395d30748a01825ef90891921e"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages356da5aaf38f980060d17905398301033e9eb45c2552bf281fa7fd4c8e23ebddbotocore-1.34.14.tar.gz"
    sha256 "041bed0852649cab7e4dcd4d87f9d1cc084467fb846e5b60015e014761d96414"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages365104defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages90c76dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesa0b54c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40bas3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("bash -c '. #{bin}awsume -v 2>&1'")

    file_path = File.expand_path("~.awsumeconfig.yaml")
    shell_output(File.exist?(file_path))

    assert_match "PROFILE  TYPE  SOURCE  MFA?  REGION  PARTITION  ACCOUNT",
                 shell_output("bash -c '. #{bin}awsume --list-profiles 2>&1'")
  end
end