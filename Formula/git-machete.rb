class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.16.3.tar.gz"
  sha256 "ad17addd60a8c213fb4bb233c4040a59a16c5b7c3e67f2ee0f4aaff54a794dd1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40f541aba4f1ba24c4a227a2eeb6126fc438fbbb520a3ca274a76b4974509c8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40f541aba4f1ba24c4a227a2eeb6126fc438fbbb520a3ca274a76b4974509c8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40f541aba4f1ba24c4a227a2eeb6126fc438fbbb520a3ca274a76b4974509c8e"
    sha256 cellar: :any_skip_relocation, ventura:        "7d3dd948b35fd0a7a6008f37ef1180cc4a4a5db40b2525e790f537b1f7328538"
    sha256 cellar: :any_skip_relocation, monterey:       "7d3dd948b35fd0a7a6008f37ef1180cc4a4a5db40b2525e790f537b1f7328538"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d3dd948b35fd0a7a6008f37ef1180cc4a4a5db40b2525e790f537b1f7328538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b369f95c1465b2e9432fa4a44d1195a30d56b4d17ce6cc8b65af8ff5a2403cf"
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