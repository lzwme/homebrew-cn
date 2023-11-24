class GitMachete < Formula
  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.20.0.tar.gz"
  sha256 "30020434d46f0102fe8018ba0262dc73e81c512018cdb77281a93531b7b66499"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "055189ad21194f9bfcde65bf3078bb9039646358da8759c52ee6c28b6202025a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9255e892b8fea8cbdaaed51ca899b8ef0b218e0015a68755fd5ab5fce5b8e9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "318cf19ddcb085e73126fd17282088ea8f6c01b22db88d2f18083b7a4d108e58"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ca6e41e31b14be6ae9ce96d932d0024723cb59ff3ba5082e3c8743b5786f370"
    sha256 cellar: :any_skip_relocation, ventura:        "a49fbfb2224c0144faaa4c04b9c4e4cca871894fbb4d1d56dca4d3feab3c91c7"
    sha256 cellar: :any_skip_relocation, monterey:       "366c54a12d379ba80ce49b1222ef90a4b43b6904c8e78fb3dd71c1bfb53a03db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a60b9e7101cf304ba1ed7c6433e4997836811a217cfbddac64b621f4ddf8288"
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