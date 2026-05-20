class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://files.pythonhosted.org/packages/55/e4/3352f18462fb22946881affa7c04986fd50c9720d2b1ecb66e7590b63a24/git_machete-3.41.0.tar.gz"
  sha256 "16d11d226e7d054c4aa8222921c7a0377eee67c485f304170fc44eddc76d77bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a450ea36be88acfe306537821e8a4da4d2aba965bd6f7b6f91325fbe5ba4b8a"
  end

  depends_on "python@3.14"

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