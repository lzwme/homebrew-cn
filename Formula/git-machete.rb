class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.16.2.tar.gz"
  sha256 "5bec73f3141bb2bd02bda28947acc782919413ec96a29dd0b6fd3ea53b4d00d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddd84009e9aec653ee7c8f065c91db0b9554368685171169e3820619b11b8bfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddd84009e9aec653ee7c8f065c91db0b9554368685171169e3820619b11b8bfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddd84009e9aec653ee7c8f065c91db0b9554368685171169e3820619b11b8bfc"
    sha256 cellar: :any_skip_relocation, ventura:        "ce3f53b62935802d32ed1b48a32a24b056d7e5123c1be46947881b248123857c"
    sha256 cellar: :any_skip_relocation, monterey:       "ce3f53b62935802d32ed1b48a32a24b056d7e5123c1be46947881b248123857c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce3f53b62935802d32ed1b48a32a24b056d7e5123c1be46947881b248123857c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "201213a32a2e7a9b08869c163bc63b50f85fecda74e0fcd045d3437e3770ef22"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources

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