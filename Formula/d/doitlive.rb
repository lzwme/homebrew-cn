class Doitlive < Formula
  include Language::Python::Virtualenv

  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/32/75/c94e4d4e7fac8606e199fad35a00b33e4252d00078f25285f91e97e546c0/doitlive-5.1.0.tar.gz"
  sha256 "b6bcd25f9f037b7e96e34d68549306adb3e8c83f6e92c51ec2b225abc05b25c5"
  license "MIT"
  revision 3
  head "https://github.com/sloria/doitlive.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd010ee60ee386929902d4a84e49dcaef0252b8fd99f5cc3a9423c3c2577ecec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9d3ac22c0a128fb6cd4a53a17c220eed94b443c6b902d6ee8bd0e68ed98adc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7a7fd196cb81600a7161cc3eb47ca2c05249e23e93ba5832db769a6070a59b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a974646bdea613259542c41e6c171196d8ee4a4b4f0ea1ede12b0cdc11b0ba1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81e48751a6148e9dfb71de1a4853b5db9b62fde4aca9cc3b6d18d93d13c7ff93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f9590f214b22bb78730e0e5927dd6869ed4e6dd842218260936bac237fb0c6e"
  end

  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "click-completion" do
    url "https://files.pythonhosted.org/packages/93/18/74e2542defdda23b021b12b835b7abbd0fc55896aa8d77af280ad65aa406/click-completion-0.5.2.tar.gz"
    sha256 "5bf816b81367e638a190b6e91b50779007d14301b3f9f3145d68e3cade7bce86"
  end

  resource "click-didyoumean" do
    url "https://files.pythonhosted.org/packages/30/ce/217289b77c590ea1e7c24242d9ddd6e249e52c795ff10fac2c50062c48cb/click_didyoumean-0.3.1.tar.gz"
    sha256 "4f82fdff0dbe64ef8ab2279bd6aa3f6a99c3b28c05aa09cbfc07c9d7fbb5a463"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"doitlive", "completion", shell_parameter_format: :none)
  end

  test do
    system bin/"doitlive", "themes", "--preview"
  end
end