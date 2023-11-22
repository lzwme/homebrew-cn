class Athenacli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for AWS Athena service"
  homepage "https://athenacli.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/38/1a/d9cd6c68a4a1cd2ce779b163f8cec390ae82c684caa920d0360094886b1f/athenacli-1.6.8.tar.gz"
  sha256 "c7733433f2795d250e3c23b134136fea571ea9868c15f424875cd194eaeb7246"
  license "BSD-3-Clause"
  revision 4

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fcdf94cd59473c98284d7569705a56c6ad625db5d06f33bd50c8b4d3eecc15c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce17baa64bcd547eda34e67d12c3bc3551b4c619181fa070c3de8302c85e456d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55c23ee0fa5f3b48629800507ce39944c41b18b9bd7e70bfbaf58d2231335173"
    sha256 cellar: :any_skip_relocation, sonoma:         "990952650f257457e3288b1234b1656d49cc1d7f4d67039f1d8373d08f83b5a7"
    sha256 cellar: :any_skip_relocation, ventura:        "34ab3851c1ceeb8235dfbd44fdbc1b23335a6efe05e3702c1290aa8ee76a57f7"
    sha256 cellar: :any_skip_relocation, monterey:       "0ff5d960a8df45d4b115b5ee9ab40117211e20a59c3e4ad5dc9575f5a1cbc02f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64e46f00e9faaccb0e76ccfc5a9cea531aa97f11304ad2349c615cb78135ad19"
  end

  depends_on "python-click"
  depends_on "python-dateutil"
  depends_on "python-tabulate"
  depends_on "python@3.12"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/1b/2f/4ccd05e765a9aa3222125da37ceced40b4133094069c4d011ca7ae37681f/boto3-1.28.65.tar.gz"
    sha256 "9d52a1605657aeb5b19b09cfc01d9a92f88a616a5daf5479a59656d6341ea6b3"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/42/30/e5e2126eca77baedbf51e48241c898d99784d272bcf2fb47f5a10360e555/botocore-1.31.65.tar.gz"
    sha256 "90716c6f1af97e5c2f516e9a3379767ebdddcc6cbed79b026fa5038ce4e5e43e"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/27/01/6aaa4fc415274ac77372b4d259c234b9f5bfc8d78144c3fda1f3019d4690/cli_helpers-2.3.0.tar.gz"
    sha256 "e7174d003a2b58fd3e31a73fbbc45d5aa513de62cbd42d437f78b9658bd5f967"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/bd/c1/b9dbe600903f9ac2401e42f38cb376130485a6d0db611f60ab05fa8d21fc/fsspec-2023.9.2.tar.gz"
    sha256 "80bfb8c70cc27b2178cc62a935ecf242fc6e8c3fb801f9c571fc01b1e715ba7d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "pyathena" do
    url "https://files.pythonhosted.org/packages/13/cd/57fcf54bcdd59e93cdd84cfe8c0203b63cb1cb34f9543acfc1f95a69aa12/pyathena-3.0.9.tar.gz"
    sha256 "446538505f8d85f7362c642561ff089ab9837f6d34f494d2c7a70ee28dd5b832"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/15/53/5345177cafa79a49e02c27102019a01ef1682ab170d2138deca47a4c8924/Pygments-2.11.1.tar.gz"
    sha256 "59b895e326f0fb0d733fd28c6839bd18ad0687ba20efc26d4277fd1d30b971f4"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
    sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/89/3c/253e1627262373784bf9355db9d6f20d2d8831d79f91e9cca48050cddcc2/tenacity-8.2.3.tar.gz"
    sha256 "5398ef0d78e63f40007c1fb4c0bff96e1911394d2fa8d194f77619c05ff6cc8a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/cb/ee/20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04ba/wcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    init_run_output = shell_output("#{bin}/athenacli 2>&1", 1)
    assert_match "Welcome to athenacli!", init_run_output
    assert_match "we generated a default config file for you", init_run_output

    regular_run_output = shell_output("#{bin}/athenacli 2>&1", 1)
    assert_match "`s3_staging_dir` or `work_group` not found", regular_run_output
  end
end