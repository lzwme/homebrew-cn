class GitMachete < Formula
  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.21.0.tar.gz"
  sha256 "d4fd2e92f149f50f600b590708b96ffb6104a85463c2c17e17ef5390558ffde7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "329023ec322cf2ccd3d1fb6c6b02b183b9e7135ed41eb597fb43eeea08fc212d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "371f59d83f3853d0cea85ad9554e905043378872ada98ce5d46d3c87e5f52b3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f7cce793781f6c222a6c2f0ec5d92c7d94479c8f9f0a9a23b961eb47d31b74f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e66cad1ba70d4bc5029a8f30fecc138ce110dd2da5b31b4d0513329aaa4da55"
    sha256 cellar: :any_skip_relocation, ventura:        "426b55a7175c21369aab490feb71bd27cfc4bd1379a9f4c02ace01c548006ad4"
    sha256 cellar: :any_skip_relocation, monterey:       "badbc10d5b893b5c3131ec87d0260714f9eacc96266f0029f8b6fb7cca975c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09b7bab8d0c321b1cf69536274f9f3020351edf507d77038ca8d9943ad16bf29"
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