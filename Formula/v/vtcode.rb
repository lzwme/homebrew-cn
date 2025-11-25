class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.47.4.crate"
  sha256 "afb451c3e8dcfea6d908cf990996f01e0cfb9b2f9eb10393d72f2846f23f7f24"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0b7292e8a5c712e9e31f0419f2645e22427525ac8cf5a7924e1661257ba107e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3287d2e9d836e2f6e2281f885c04fe2fc6c5172dea433c22080c73bd994038f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbcb3a429d94ec79fd5059d4b081586ea0ac25fa70606c79171ed6a490dffcc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "05808e778ab8a0240b965f17919706575969611c27ebab58ccdb36ffda6c1d5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "140b68222d27b415e16b5f9954b2a84a1eaee3a667bc6ebadf149a20503a4b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10c0442cd7fedfedcc6842e67c7071ca100c020bb9feae5a2e43627e72d5a5e6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end