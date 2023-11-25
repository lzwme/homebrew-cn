class Athenacli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for AWS Athena service"
  homepage "https://athenacli.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/38/1a/d9cd6c68a4a1cd2ce779b163f8cec390ae82c684caa920d0360094886b1f/athenacli-1.6.8.tar.gz"
  sha256 "c7733433f2795d250e3c23b134136fea571ea9868c15f424875cd194eaeb7246"
  license "BSD-3-Clause"
  revision 4

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "beaafab88d75e1783e6b65386388bd7095608362038fd836b53f2539eca3235b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "388158fae140932a33955829a561c95dcd36a05755c57867fb3a20b0b5597154"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97b756d9124bdc0265e96b11341f786f9db6b2409cbaa5ae4331dcc6cbad90db"
    sha256 cellar: :any_skip_relocation, sonoma:         "50e559097ffffea59fc3060e24582c9236634af8e7c02db22d06b6dd24b26014"
    sha256 cellar: :any_skip_relocation, ventura:        "ae40c9ea1ab30560e00c847470f22567d0f881ed5aa2ee1670299b07e80e44ef"
    sha256 cellar: :any_skip_relocation, monterey:       "04270f20a79cc91e69b882cae733d4039f1c7d95c76197fb726734ef1c2dd9e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b29979716ea747fa53e2163a41241c86d8e87cf63063165778b566ec9a8423a"
  end

  depends_on "pygments"
  depends_on "python-click"
  depends_on "python-dateutil"
  depends_on "python-tabulate"
  depends_on "python-urllib3"
  depends_on "python@3.12"
  depends_on "six"
  depends_on "sqlparse"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/d7/1e/919989cd5ffc34ac7bc1107cca3eb1a9e03bbe05232c5ae61f923ecb689e/boto3-1.29.6.tar.gz"
    sha256 "d1d0d979a70bf9b0b13ae3b017f8523708ad953f62d16f39a602d67ee9b25554"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/52/03/dbfdf303237d40ff65d63dfbbafffc90ce5bdad208f23babbff0587c6260/botocore-1.32.6.tar.gz"
    sha256 "ecec876103783b5efe6099762dda60c2af67e45f7c0ab4568e8265d11c6c449b"
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
    url "https://files.pythonhosted.org/packages/a4/f7/16ec1f92523165d10301cfa8cb83df0356dbe615d4ca5ed611a16f53e09a/fsspec-2023.10.0.tar.gz"
    sha256 "330c66757591df346ad3091a53bd907e15348c2ba17d63fd54f5c39c4457d2a5"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/d9/7b/7d88d94427e1e179e0a62818e68335cf969af5ca38033c0ca02237ab6ee7/prompt_toolkit-3.0.41.tar.gz"
    sha256 "941367d97fc815548822aa26c2a269fdc4eb21e9ec05fc5d447cf09bad5d75f0"
  end

  resource "pyathena" do
    url "https://files.pythonhosted.org/packages/77/7e/e04e79b7ca5327b517b899152f3c88d1942397dd1d7f246819f1e7971f29/pyathena-3.0.10.tar.gz"
    sha256 "1ef983d478bc182c2ea31d75bf4fd5755425985e5da4f8e181235f2d2733e536"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/89/3c/253e1627262373784bf9355db9d6f20d2d8831d79f91e9cca48050cddcc2/tenacity-8.2.3.tar.gz"
    sha256 "5398ef0d78e63f40007c1fb4c0bff96e1911394d2fa8d194f77619c05ff6cc8a"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/d7/12/63deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24/wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
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