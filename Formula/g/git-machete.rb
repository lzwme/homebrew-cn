class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https:github.comVirtusLabgit-machete"
  url "https:files.pythonhosted.orgpackagesba34066cfb595e14968c70fc2bfc61858fd9039c5ae5f9aac2af150c3a9a76fcgit_machete-3.26.1.tar.gz"
  sha256 "a0802cb9c70879365ef51da8213ed20c7c118ec076a35143eda97301935b91d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa9132c8317ab326b01e09561fb45cff026aff0314b09a92aa3fb48fda4aebc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa9132c8317ab326b01e09561fb45cff026aff0314b09a92aa3fb48fda4aebc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa9132c8317ab326b01e09561fb45cff026aff0314b09a92aa3fb48fda4aebc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa9132c8317ab326b01e09561fb45cff026aff0314b09a92aa3fb48fda4aebc8"
    sha256 cellar: :any_skip_relocation, ventura:        "fa9132c8317ab326b01e09561fb45cff026aff0314b09a92aa3fb48fda4aebc8"
    sha256 cellar: :any_skip_relocation, monterey:       "fa9132c8317ab326b01e09561fb45cff026aff0314b09a92aa3fb48fda4aebc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52de9878ca479f1d5c6b9ecab811e0c01c27c402a2c22735a8ca501ab15aff62"
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