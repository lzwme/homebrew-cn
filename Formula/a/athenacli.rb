class Athenacli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for AWS Athena service"
  homepage "https://athenacli.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/38/1a/d9cd6c68a4a1cd2ce779b163f8cec390ae82c684caa920d0360094886b1f/athenacli-1.6.8.tar.gz"
  sha256 "c7733433f2795d250e3c23b134136fea571ea9868c15f424875cd194eaeb7246"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c2092e8e48ec0eeae9aae29e678e784f5a917fbc9495fded63d8d04211bcce9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2152d1aca8a2873ed1557a9480803ea146c5bbb2bb49c9b1779432f2f00d710d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "860ca233b7c1a1c4e433ae552bd7d798db0d4e14f82edbf25ea7fe5b75ee08b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "264b94c58f133f6996f3cc662c7a78bfad75d0dd414764ee585ff28fa6e182e6"
    sha256 cellar: :any_skip_relocation, ventura:        "13a510ce645b642715870831973ae12d78b60a8c863eb8ab64c7edfb9211857c"
    sha256 cellar: :any_skip_relocation, monterey:       "eccd083610a38d72ae54d0a5e1285e0b36c3fe65abc694925496e337ad9b30f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f85747d35edb9304c6ac01b8dc291d2e600401d204539b848f6ff13902b58b26"
  end

  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/a8/23/ef75674c1ef3bf77479a5566a1a7c642206298feec1f7012e4710a5b35f4/boto3-1.28.58.tar.gz"
    sha256 "2f18d2dac5d9229e8485b556eb58b7b95fca91bbf002f63bf9c39209f513f6e6"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/77/1d/bd7a7383a2aff3cbf01c758a5507106ac7459707b241d8afbf336520f142/botocore-1.31.58.tar.gz"
    sha256 "002f8bdca8efde50ae7267f342bc1d03a71d76024ce3949e4ffdd1151581c53e"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/27/01/6aaa4fc415274ac77372b4d259c234b9f5bfc8d78144c3fda1f3019d4690/cli_helpers-2.3.0.tar.gz"
    sha256 "e7174d003a2b58fd3e31a73fbbc45d5aa513de62cbd42d437f78b9658bd5f967"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
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
    url "https://files.pythonhosted.org/packages/df/3f/e902a1d63e57789cba4c176f1580497ba704a23a0b7d62f372c96bcfaff3/pyathena-3.0.8.tar.gz"
    sha256 "0ea463b4c4a5ca8d8f0788a93a93f11445a5fd1b8a953df259d773092e4d2fdf"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/15/53/5345177cafa79a49e02c27102019a01ef1682ab170d2138deca47a4c8924/Pygments-2.11.1.tar.gz"
    sha256 "59b895e326f0fb0d733fd28c6839bd18ad0687ba20efc26d4277fd1d30b971f4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
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
    url "https://files.pythonhosted.org/packages/dd/19/9e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511/urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
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