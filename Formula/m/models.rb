class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://reyamira.github.io/models/"
  url "https://ghfast.top/https://github.com/reyamira/models/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "b747f3669a41926af9cdeb74e2d8e8f65d18479598c582ac5b6c541101355a60"
  license "MIT"
  head "https://github.com/reyamira/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8eb6d646acfcf970063f472a5e0f8fc929986fd49576fa7910f9e2bc30eba4d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4167f77779319fb9daac5201c6d3a43785cdc500389ef568c3b1a244a986865b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75e9ce5da85e286c4f20c29d0fe43ffbb59c75f8925d4043b9413d175b4bc284"
    sha256 cellar: :any_skip_relocation, sonoma:        "df9061fc261074b80fe9f912ffc0c9bfbe754a9ae52df98a45ba0851e058106e"
    sha256 cellar: :any,                 arm64_linux:   "5330ef5df7b86bdfb39b8b9021a76dd3a1ddfca2e6bd1a185b060ecff187452b"
    sha256 cellar: :any,                 x86_64_linux:  "f4cfbd92c64e62f2e38a4afee34d6c08ba2e698ec78750b4669b66987fb3e5e8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/models --version")
    assert_match "claude-code", shell_output("#{bin}/models agents list-sources")
  end
end