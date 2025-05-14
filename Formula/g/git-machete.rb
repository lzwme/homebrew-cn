class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https:github.comVirtusLabgit-machete"
  url "https:files.pythonhosted.orgpackagesed3d286c1d6fd3e37b22b0d26291874e5e2b7e3749879dd508afac3502f220b6git_machete-3.35.0.tar.gz"
  sha256 "e6986362955060d31f0b3dd797e11e0caf6c081bb532d141cd571f445625b1ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "983dff8968437cf9167387da592ff6ca0adbf4f91e31b9f48aad719d2c34a4ce"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources

    man1.install "docsmangit-machete.1"

    bash_completion.install "completiongit-machete.completion.bash" => "git-machete"
    zsh_completion.install "completiongit-machete.completion.zsh" => "_git-machete"
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