class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.17.5.tar.gz"
  sha256 "eda6bc8f920b18ae1b2d77b249299efa09da33bff3dd550c5662ebff76604d9e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f87c5c94c8a16122efa8961d56ebb398aafa49aef70ae61c444a96242ae98055"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f87c5c94c8a16122efa8961d56ebb398aafa49aef70ae61c444a96242ae98055"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f87c5c94c8a16122efa8961d56ebb398aafa49aef70ae61c444a96242ae98055"
    sha256 cellar: :any_skip_relocation, ventura:        "b4feae9cad85f9b91030a321a0e908b8fea0521584f65e092b3cb6df5551cea4"
    sha256 cellar: :any_skip_relocation, monterey:       "b4feae9cad85f9b91030a321a0e908b8fea0521584f65e092b3cb6df5551cea4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4feae9cad85f9b91030a321a0e908b8fea0521584f65e092b3cb6df5551cea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b15387fa37b0f94ed3240dd2c8030562043d9d90bdfebd55aa9daa9ff72c4b9f"
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