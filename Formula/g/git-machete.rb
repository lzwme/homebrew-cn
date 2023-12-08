class GitMachete < Formula
  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.21.1.tar.gz"
  sha256 "fd5ad85064f268ff4f05f43951bc89b8e9958e86a809cf33f8ec1dfd1f074cf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c704b34661d16d370d6d42543997f974e5c6b213cc7d95b4e5f0c5fabd06b5e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0801583bb67f3df98ec6cf6797dfcb005eeb13be52dfd71aa4459fe84c8d65bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f65b3ffc89c58af27bb34e1b86eb92ac425f27d90ae42438801e75943b470f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9089ca61b2e3b46b504d23b34fd6fe95b4f8121287d94469b8e6bd3c926b003"
    sha256 cellar: :any_skip_relocation, ventura:        "91e184df16ecafdd06bf1bd7b8e600700df065c8b87d5982165b9922ad72e70d"
    sha256 cellar: :any_skip_relocation, monterey:       "089c82efc09cd711eea20b018a4c6645a59678d6c419caca26e598bc4f51b201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "726d58c9b77134c3e6157080a717ce4786bcf41d459e89be14ca7ba3d3fbd8c5"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."

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