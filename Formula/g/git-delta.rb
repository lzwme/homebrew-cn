class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https:github.comdandavisondelta"
  url "https:github.comdandavisondeltaarchiverefstags0.18.2.tar.gz"
  sha256 "64717c3b3335b44a252b8e99713e080cbf7944308b96252bc175317b10004f02"
  license "MIT"
  revision 2
  head "https:github.comdandavisondelta.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4bb9a2113f9fb21101c8d4bcc11b37048a008ddf0c140cdcfa7e1bbbf8650e55"
    sha256 cellar: :any,                 arm64_sonoma:  "0b9bb3ae47e22b36121b5ff4c87422cf356705f9c7eaf1bfc9d011489bb0a9c4"
    sha256 cellar: :any,                 arm64_ventura: "2be672321d53b1c798d3997088e015d0a038bbe94dd5797c298ef167eee0c959"
    sha256 cellar: :any,                 sonoma:        "28949d77b77db2413a12e397d3292d050603be2d7e491ee2406a1c41a87224a9"
    sha256 cellar: :any,                 ventura:       "93c87379b5ea08686f959f9d5b8f6bb52e59cbf549b38a0f1ed9e06907ccae87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "086c0c46d5ad7ef03a390e168ddf375c2e8b9734bdca0338f4aa5d879eea62d9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
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

    generate_completions_from_executable(bin"delta", "--generate-completion")
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