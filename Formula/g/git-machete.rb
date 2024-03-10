class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https:github.comVirtusLabgit-machete"
  url "https:files.pythonhosted.orgpackagesf3fc5799f4a6f424a86c8607c195dc6c9066f4fca9050e377f6fe46b9cc654adgit-machete-3.24.1.tar.gz"
  sha256 "31f06ba0a0412647fd4977bca487e100820a72cca473869082314f20276802bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a18818cc00173981dc30f8b954364f0cb44450cb5b5df52054a40cfedbd463f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a18818cc00173981dc30f8b954364f0cb44450cb5b5df52054a40cfedbd463f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a18818cc00173981dc30f8b954364f0cb44450cb5b5df52054a40cfedbd463f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5c9feab79eb014c4ce8019e8ca51865496156c10a5eb214b624e1964736b742"
    sha256 cellar: :any_skip_relocation, ventura:        "c5c9feab79eb014c4ce8019e8ca51865496156c10a5eb214b624e1964736b742"
    sha256 cellar: :any_skip_relocation, monterey:       "c5c9feab79eb014c4ce8019e8ca51865496156c10a5eb214b624e1964736b742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcec3fac888b0a4978711e0438572ed1cfe5a3de752ec595117a1286ed5df255"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources

    man1.install "docsmangit-machete.1"

    bash_completion.install "completiongit-machete.completion.bash"
    zsh_completion.install "completiongit-machete.completion.zsh"
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