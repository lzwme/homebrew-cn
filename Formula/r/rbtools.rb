class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/19/ef/8900501b1af41d2485ee1eabb9f3e309f80fdae911c97927d8917ae99f9f/RBTools-4.1.tar.gz"
  sha256 "24efb20346b905c9be0464e747ee1bdee7967d1b94175697ea0c830d929475ff"
  license "MIT"
  revision 1
  head "https://github.com/reviewboard/rbtools.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69280826a39dfbc55cf94d1f11ade8470fa9cb7ee9ef11632b5d3536b05ca9c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26aeb7fe73faeea93d442b37823cfcbaf5189a8656d7e936ed2940aac807c3e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b560aa4a189b1173b8b9603c9d77db164e77be52ce501f4009dfb6bdec7a5388"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b34ef6e62a88f7ec2b3733bf86b132bdc087ea3ceda1a499c44afc2711da94f"
    sha256 cellar: :any_skip_relocation, ventura:        "87c27f7a7ac77b1778a201a9816aee74bec0a06cd781c31b90a2d51c719f2701"
    sha256 cellar: :any_skip_relocation, monterey:       "d35dbece581ba434a3cafbe23c999a320de72f06792a3d12981c5a6e1aceea6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1717944e7cdbf970f9682049d4b634172ef659778f4c311c621ba12f270932d4"
  end

  depends_on "python-certifi"
  depends_on "python-setuptools"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "pydiffx" do
    url "https://files.pythonhosted.org/packages/d3/76/ad0677d82b7c75deb4da63151d463a9f90e97f3817b83f4e3f74034eb384/pydiffx-1.1.tar.gz"
    sha256 "0986dbb0a87cbf79e244e2f1c0e2b696d8e86b3861ea2955757a61d38e139228"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/1c/dc/0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2/texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  def install
    virtualenv_install_with_resources
    bash_completion.install "rbtools/commands/conf/rbt-bash-completion" => "rbt"
    zsh_completion.install "rbtools/commands/conf/_rbt-zsh-completion" => "_rbt"
  end

  test do
    system "git", "init"
    system "#{bin}/rbt", "setup-repo", "--server", "https://demo.reviewboard.org"
    out = shell_output("#{bin}/rbt clear-cache")
    assert_match "Cleared cache in", out
  end
end