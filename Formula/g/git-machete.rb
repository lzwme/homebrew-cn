class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https:github.comVirtusLabgit-machete"
  url "https:files.pythonhosted.orgpackagesc738ae61b6862ec6607cc0d93dc139d7c259d6c5a21b90c9aeb148c81101d6a8git_machete-3.33.0.tar.gz"
  sha256 "0d4c9d512ec7666b0100e4fc6e0ccf8d4218f0e941db6b3926894b2b1bfd5b76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e5e4ed4b7fe8ec24862e3b6bf20942a66e98de08a9d16983e8769fdc51999f58"
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