class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https:github.comVirtusLabgit-machete"
  url "https:files.pythonhosted.orgpackages0d54f491974bde343bc7ce2de8736f69fc5439fed31a72a0904c713e503a712dgit_machete-3.36.0.tar.gz"
  sha256 "7e77863dc0cdf2d95c5059798a33c70426bda0588af99fad2ebe912d9058979d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d32b84bc28c4536fe545ac2881d74ee8b3a96defe2bd0ec006d2b03d6446aa29"
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