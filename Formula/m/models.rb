class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://ghfast.top/https://github.com/arimxyer/models/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "61cb59a3e38f262635f0dfde63c0a0366f0eea6ec00fa856249614ff5ae16fa3"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71ffbc0871a553e10cf0a40980c1288a70433ad44b431b851f35a38242846ba6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "424b155e8670995e29918fdb9258e9c9f9262dfbfd4e8f11133e1eede7a90e5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b57065e374259e2c43402d6dab8e039ae9702eb74383752449ce05512510781"
    sha256 cellar: :any_skip_relocation, sonoma:        "345133e8763d4285843c98e21c17bcddbdbd270d96ee854bb41741710f3241da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77ebab66a61d8aa3853e32867a693ffafd34d850d272ac891d2e8006b4498d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "add06a2015ed23081c0f8cd546ae8d1e80ecd27ae17a7b3fa2d7fad404bf5854"
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