class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://ghfast.top/https://github.com/idursun/jjui/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "a6167021279bffab6915f19f133c01eb0cfa1800220e4368193e1b8e1ead4f44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a0db2c8ff9874f7ca219f93f4203748a0e7a9203d0b5239b9cdb3483487dd8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a0db2c8ff9874f7ca219f93f4203748a0e7a9203d0b5239b9cdb3483487dd8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a0db2c8ff9874f7ca219f93f4203748a0e7a9203d0b5239b9cdb3483487dd8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f78c1b558e3c8d73f52d6fe4f4515aad90adbc0393d950f68a2769bb48c728ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b66136766b60d8be173a540c598b33497adbb6b1d8b278ffd8a16e6d6ef08cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aae692cb15e5df39081dcac755edd03483ca0c1f9819ef8a4fec1e3fc7ea59a4"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end