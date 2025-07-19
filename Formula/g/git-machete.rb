class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://files.pythonhosted.org/packages/89/03/e474cacf6d5e28029ae0f82ba116226744475517ea9e6349734512e25af8/git_machete-3.36.2.tar.gz"
  sha256 "e35f766154d36e78b8227f288c2068ae22b95fb842f5fe2767c00cf2bb70d3f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1965b28821e5b5d419299ce920f82869b71ecdfdd7c689d7faa7c7dfb75e74e5"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources

    man1.install "docs/man/git-machete.1"

    bash_completion.install "completion/git-machete.completion.bash" => "git-machete"
    zsh_completion.install "completion/git-machete.completion.zsh" => "_git-machete"
    fish_completion.install "completion/git-machete.fish"
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"
    system "git", "branch", "-m", "main"
    system "git", "checkout", "-b", "develop"
    (testpath/"test2").write "bar"
    system "git", "add", "test2"
    system "git", "commit", "--message", "Other commit"

    (testpath/".git/machete").write "main\n  develop"
    expected_output = "  main\n  |\n  | Other commit\n  o-develop *\n"
    assert_equal expected_output, shell_output("git machete status --list-commits")
  end
end