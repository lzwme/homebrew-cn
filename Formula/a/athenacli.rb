class Athenacli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for AWS Athena service"
  homepage "https://athenacli.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/31/1b/fb72060d66d8afaaba86b5ead8c4edaf4a37a2a175baa8ac391c3ee60a48/athenacli-1.7.0.tar.gz"
  sha256 "1c81f420035ae4d6ed202da659ba640982880c65c7e7755c0b5a6d25adc2ac25"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "85eaea0d865a41d6c88d4b3c054d4d2054249f8db70052996fe1222e2b95fbcb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "04441fe488e15e27377bb3fff9bdcd7f7e5a254fed8bd26487f7472b1a19e731"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "35ae975070f7ab57defd021f955ac9a52d250fc4c83c37da97b9c54daaae7f32"
    sha256 cellar: :any,                 arm64_linux:       "20a927850697e9ddcf138b7a5e3bfeddc0971abe13c14af0113d7ca3e464bf8b"
    sha256 cellar: :any,                 x86_64_linux:      "d0c49cccc3ba19fb188a658feeaa3b1beab8760853813f7ab3ab9c6d5cde15df"
  end

  depends_on "python@3.14"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/75/46/d8c87ada70a7647fb3d206c7f19eafca3580a0ae4c06d62da539a1ee1207/boto3-1.43.105.tar.gz"
    sha256 "e51260aed9cc1474778b5488bc6f97ad28f27a0a7002f4bbaaf8191aff1422ea"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2b/30/668f3c0533a440787e212cf56404cb6ec234ae8e6baf97fe17329d512d88/botocore-1.43.105.tar.gz"
    sha256 "afb3e7706b123ab069d1c34571ca1fdf82528a48425574fe4693df3d039d503f"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/3f/de/278f4885fcd03661ab9b69dba9fc745c27d820858dbc06e427057899dcf5/cli_helpers-2.15.1.tar.gz"
    sha256 "e9c0826dda2855745eb63b3fd8e33b6ac8881188f2ba91e51a516ed833fc0cb8"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/77/cd/9be253869fc42e764de7f3dedd6969af7d44ff9c3375214a3442a6f3fc08/fsspec-2026.9.0.tar.gz"
    sha256 "0f08147951c8cb31d844c3547d631053b127863b60be04cf06e121333ee0e2fe"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "pyathena" do
    url "https://files.pythonhosted.org/packages/dc/57/25d419dfffb2ceadcefce4a9cf8f56d0bcaf76f7b8db8a39c1d4f2ac7835/pyathena-3.37.0.tar.gz"
    sha256 "ca3ce3ef18ededcd2c45ce2ebfaca9e9aaf9249161749a72f47062feb44037ea"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/15/53/5345177cafa79a49e02c27102019a01ef1682ab170d2138deca47a4c8924/Pygments-2.11.1.tar.gz"
    sha256 "59b895e326f0fb0d733fd28c6839bd18ad0687ba20efc26d4277fd1d30b971f4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
    sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/47/c6/ee486fd809e357697ee8a44d3d69222b344920433d3b6666ccd9b374630c/tenacity-9.1.4.tar.gz"
    sha256 "adb31d4c263f2bd041081ab33b498309a57c77f9acf2db65aadf0898179cf93a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/dc/ac/3a943d2792c9bb368aaa8b50121c0f778460ba2d7fbdc0a0366201d9e761/wcwidth-0.9.1.tar.gz"
    sha256 "5823209b0d43af322ce698c689380d7c15ca31fa8e6e3be8459f27031bef0af5"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"athenacli", shell_parameter_format: :click)
  end

  test do
    init_run_output = shell_output("#{bin}/athenacli 2>&1", 1)
    assert_match "Welcome to athenacli!", init_run_output
    assert_match "we generated a default config file for you", init_run_output

    regular_run_output = shell_output("#{bin}/athenacli 2>&1", 1)
    assert_match "`s3_staging_dir` or `work_group` not found", regular_run_output
  end
end