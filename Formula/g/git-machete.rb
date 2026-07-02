class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://files.pythonhosted.org/packages/d2/ba/4717ff3d30455cbadf7efd9c0e98aa52b4db2cb0353bd3bd5e91ee3bd483/git_machete-3.44.0.tar.gz"
  sha256 "b872ab1903eee29c177f004b35fde9a64791817b42d4b634c83ee2b60cfc2faa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fbe914d98c0ad7f2356bb78a3791281e5d933fe941fa75f3669bf4b549a7a27e"
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