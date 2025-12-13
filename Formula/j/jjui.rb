class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://ghfast.top/https://github.com/idursun/jjui/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "2752e6586c1cd010d077aff202d7da00923c593bd8e124d17c6b44804a521a93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7eab8f4970c0d8bdd698d26b37ad12453bba2fb1d688de2ed0a673760126d6a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eab8f4970c0d8bdd698d26b37ad12453bba2fb1d688de2ed0a673760126d6a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eab8f4970c0d8bdd698d26b37ad12453bba2fb1d688de2ed0a673760126d6a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "76223739ce82fad6fdae3fe7d587cba888bcf276275a82a78b4be6b8b084296f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "494e9c76265547bb120f327698a70ed98f59c57bbd2837fb77c4ea94fe8894fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "420af7e16efe6da7e4e6666947f1a6eb1c7e101a5bd7f7725cbc61ee484cea02"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "Error: There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end