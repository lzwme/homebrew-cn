class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https:github.comVirtusLabgit-machete"
  url "https:files.pythonhosted.orgpackagesed8077d3aa3b4dc4d561aebdf8b92eea7d693f43312dd970cea79d2e05a2af56git_machete-3.31.1.tar.gz"
  sha256 "fdb3aeb8c1fe1fd8bcb362259a50e2c285a8aab29e84e598a1220d3b235960d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8193ac2d25a936fcbd72af0bbe8f5187487ceb4396b55f56dbdc44b7cc1f4b39"
  end

  depends_on "python@3.13"

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