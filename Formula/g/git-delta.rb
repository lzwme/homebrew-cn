class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https:github.comdandavisondelta"
  url "https:github.comdandavisondeltaarchiverefstags0.18.2.tar.gz"
  sha256 "64717c3b3335b44a252b8e99713e080cbf7944308b96252bc175317b10004f02"
  license "MIT"
  revision 1
  head "https:github.comdandavisondelta.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7c6b8a8d5802e42770a3f5da3e276a3dcc2e8b7a6945c3f5e7e240e95274afe1"
    sha256 cellar: :any,                 arm64_sonoma:  "aaaa87419f0ac6b1ca16345e9299b93a4c26646bdf7b27048b4789a68c38e785"
    sha256 cellar: :any,                 arm64_ventura: "e1dd88715549906c8d75fda37aba45bebccc2feaa5152e8444739f80bf349fe6"
    sha256 cellar: :any,                 sonoma:        "4800301c726f6b22a99a9f6f9294799e9ae2b7b4625c87fbb63890358c984aaa"
    sha256 cellar: :any,                 ventura:       "ed18eb50a566ddbae43d7cfad0e090e8774a213ed3a6a7a7d3832c7e23a59469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ea94075ccecbdb82e38f3b57a2e08ec6c46958fd6f723c11c6515e359985b07"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "oniguruma"

  uses_from_macos "zlib"

  # support libgit2 1.8, https:github.comdandavisondeltapull1930
  patch do
    url "https:github.comdandavisondeltacommitb90f249f7186696bb104cd992d705108373d216a.patch?full_index=1"
    sha256 "a3b2839fe70c8a2452e016dff663791d42ad650f9169e210a6a8fe1a519e2939"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"delta", "--generate-completion", base_name: "delta")
  end

  test do
    assert_match "delta #{version}", shell_output("#{bin}delta --version")

    # Create a test repo
    system "git", "init"
    (testpath"test.txt").write("Hello, Homebrew!")
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Initial commit"
    (testpath"test.txt").append_lines("Hello, Delta!")
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Update test.txt"

    # Test delta with git log using pipe_output
    git_log_output = shell_output("git log -p --color=always")
    output = pipe_output(bin"delta", git_log_output)
    assert_match "Hello, Delta!", output
  end
end