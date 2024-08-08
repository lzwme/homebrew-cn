class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https:github.comVirtusLabgit-machete"
  url "https:files.pythonhosted.orgpackages4e56534872867171dd33f8a4dbba755275e4cd12f361f51d3b8f731bb4ac1b91git_machete-3.26.4.tar.gz"
  sha256 "36ca33e90c9664a2c595f29d3f91a62b5bdc9ed15f5ab8f2b748b9f0f997fefe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3fc32fc65a648048dd6e8427114ce738c69f51f7596afea60b4b16239c505c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3fc32fc65a648048dd6e8427114ce738c69f51f7596afea60b4b16239c505c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3fc32fc65a648048dd6e8427114ce738c69f51f7596afea60b4b16239c505c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3fc32fc65a648048dd6e8427114ce738c69f51f7596afea60b4b16239c505c3"
    sha256 cellar: :any_skip_relocation, ventura:        "f3fc32fc65a648048dd6e8427114ce738c69f51f7596afea60b4b16239c505c3"
    sha256 cellar: :any_skip_relocation, monterey:       "f3fc32fc65a648048dd6e8427114ce738c69f51f7596afea60b4b16239c505c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0075c24b841c165f06132c0e0ec0c9af4986d93dccc17eaa327323d0126c5e4a"
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