class GitMachete < Formula
  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https:github.comVirtusLabgit-machete"
  url "https:pypi.orgpackagessourceggit-machetegit-machete-3.23.0.tar.gz"
  sha256 "7add05fb46913e263a0d68c98a9108c077108b8910364474d33f2dd8d432cbdb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c18305105c62d82bd8dafb6c9f69d325ddec992a826d346fe58e297c810869ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e07dcb9b33033186ea74fde1d10c412b1979b79fcbd70553faf897fee0a6c111"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aed6f8c54e6eb3ab6f9b8f106e27a7e7a5eedc9e395fb6aed0ce6f011b3508a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f5ea1d36a7ff00c4939aa9a9d1b1b0e1952dbb7ae80035b403c86a3b100b1a7"
    sha256 cellar: :any_skip_relocation, ventura:        "a78c52d244bc2b07ab616ec3405bbf1794b8d14d366bb4e8a263f0c76286f9ea"
    sha256 cellar: :any_skip_relocation, monterey:       "86233095777a0dd609f0759c8241f32f250f295e89dc4ac4614af1183783d4dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6adaad5206fc74eb06ac17a6120e756655511349dc59d0be593a955806d35881"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."

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