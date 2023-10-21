class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.20.0.tar.gz"
  sha256 "30020434d46f0102fe8018ba0262dc73e81c512018cdb77281a93531b7b66499"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18bbbe4934ac2dadedf8141ccb72a936cb92990bff2de6620c1dd973d8198ef6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "347d0d7d1ebbccf07f53b14f32dfd678f32b67a95a9afc98e5c13f66527fa5c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f824f18f00fc42278e9da8412216355e2e281b3a50325702ba51decebbe53281"
    sha256 cellar: :any_skip_relocation, sonoma:         "281d1b176c51a84f868ac8164013460ec40baa7f31e5b6818be88ab74e47fda3"
    sha256 cellar: :any_skip_relocation, ventura:        "822791ea0443506a08f45197b6b07cf61a75c743bf7fadcf3d603179d62a5e82"
    sha256 cellar: :any_skip_relocation, monterey:       "6fb6c5bc3d72e2632de3547d841e47d02dc502e2126c8b9376541eb80fecd432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b618f914ddd330523df30bda47bd721a1b9945bc5186d5eea5855acca6fb0b37"
  end

  depends_on "python@3.12"

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