class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.17.8.tar.gz"
  sha256 "213a1a25d32b082d317c61f146359e9cc3df53f3cadb2687e22581118a0ac3db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "966aaaa7b9add118056c4239d485f39c31029aa0c234cd99010c5e634747d8ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "966aaaa7b9add118056c4239d485f39c31029aa0c234cd99010c5e634747d8ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "966aaaa7b9add118056c4239d485f39c31029aa0c234cd99010c5e634747d8ba"
    sha256 cellar: :any_skip_relocation, ventura:        "1c4ffdf9c9bc247cfe2bfa735a87f7a4f7f3996a4bc5f12b29b881dcd6d69033"
    sha256 cellar: :any_skip_relocation, monterey:       "1c4ffdf9c9bc247cfe2bfa735a87f7a4f7f3996a4bc5f12b29b881dcd6d69033"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c4ffdf9c9bc247cfe2bfa735a87f7a4f7f3996a4bc5f12b29b881dcd6d69033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2f71a566dda5be8dccef6b95262b283c040d236c1aa0ddf2df68ad645fa64af"
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