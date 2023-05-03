class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.17.2.tar.gz"
  sha256 "a042f096f052c762b27b7049ae67ce0f270dfa95cd65ba339acb9c0952fd3d30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42a8746df50acb411e7829bab8780cea50868b885955adf5dcbfe7d00af8d9b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42a8746df50acb411e7829bab8780cea50868b885955adf5dcbfe7d00af8d9b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42a8746df50acb411e7829bab8780cea50868b885955adf5dcbfe7d00af8d9b4"
    sha256 cellar: :any_skip_relocation, ventura:        "9333be1eb9f368f0074d01bc0a7d63be515324bfb0559051f758c5d559834ddc"
    sha256 cellar: :any_skip_relocation, monterey:       "9333be1eb9f368f0074d01bc0a7d63be515324bfb0559051f758c5d559834ddc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9333be1eb9f368f0074d01bc0a7d63be515324bfb0559051f758c5d559834ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f75004c54c8a18f1f9c1fd6f4637c30993ab6a130d53f6d9db514103d6dd070"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources

    man1.install "docs/man/git-machete.1"

    bash_completion.install "completion/git-machete.completion.bash"
    zsh_completion.install "completion/git-machete.completion.zsh"
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