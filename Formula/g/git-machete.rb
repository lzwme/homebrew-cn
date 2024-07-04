class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https:github.comVirtusLabgit-machete"
  url "https:files.pythonhosted.orgpackagescab20f4df64e4580f58ae6e170ddebf5b48acf80f2d92995a06cbee0519ee1f3git_machete-3.26.2.tar.gz"
  sha256 "373d48757f5f79c294e71d40b95057070e0f714690b7c8c22ef37c885fdad231"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "927044b24e84ed0d4f48ba6029d3bf8f63daf48c5920c29789b5197b5e3bd048"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "927044b24e84ed0d4f48ba6029d3bf8f63daf48c5920c29789b5197b5e3bd048"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "927044b24e84ed0d4f48ba6029d3bf8f63daf48c5920c29789b5197b5e3bd048"
    sha256 cellar: :any_skip_relocation, sonoma:         "927044b24e84ed0d4f48ba6029d3bf8f63daf48c5920c29789b5197b5e3bd048"
    sha256 cellar: :any_skip_relocation, ventura:        "927044b24e84ed0d4f48ba6029d3bf8f63daf48c5920c29789b5197b5e3bd048"
    sha256 cellar: :any_skip_relocation, monterey:       "927044b24e84ed0d4f48ba6029d3bf8f63daf48c5920c29789b5197b5e3bd048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "125de2617881ce939b88d5354314b391300a31171e79c01f5862042dc19d69bf"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources

    man1.install "docsmangit-machete.1"

    bash_completion.install "completiongit-machete.completion.bash"
    zsh_completion.install "completiongit-machete.completion.zsh"
    fish_completion.install "completiongit-machete.fish"
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    (testpath"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"
    system "git", "branch", "-m", "main"
    system "git", "checkout", "-b", "develop"
    (testpath"test2").write "bar"
    system "git", "add", "test2"
    system "git", "commit", "--message", "Other commit"

    (testpath".gitmachete").write "main\n  develop"
    expected_output = "  main\n  |\n  | Other commit\n  o-develop *\n"
    assert_equal expected_output, shell_output("git machete status --list-commits")
  end
end