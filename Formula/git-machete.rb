class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.17.9.tar.gz"
  sha256 "4b070117a5133c7c7e2b8bc2a927574d85edad0202da1d273c98bc7c040a8139"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ccd99e7d5bbb3a0115e0f9304f869513e734a84b187f1c098bb6aa244e9bac4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8743f2eee88b3a930ac66e6eefacbda1764f44acc1d6daa6b025395d61841535"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77940c0615b8ba06ee72ee2f44e1ff10e8528a3e9869b7fa1c521a4ed0e4cea2"
    sha256 cellar: :any_skip_relocation, ventura:        "a1bd9349b4850502a2a89d79b390fc423465ee24aba17564d799be3fee37fe37"
    sha256 cellar: :any_skip_relocation, monterey:       "8e1b876026e3d404847de98310aeb30a490de168752559f80de69b104765948b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c490d7172c3fa2b5261a9a2dfb2ea2822fccd1227c30f55706e0e6b72acb8e39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c5d1448218bc0d97b8da876d041015dd7132850b76ecac15c16364766532f30"
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