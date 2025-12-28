class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.54.1.crate"
  sha256 "8218344d855ff74a2cb3e12e11ab21ddd2d7b0358b956dac314b999911f8095a"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d6e16dd743dda1f9c7076e5a72a7445ca186a20cc5b406d11f28b48ebbfaca2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05c13520c00c8167b3b7ae6d7bb5c0ee04326a6a460cd22495426d4b2e7a96d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29f53b8c71557c1850a4bafa915585fa16d335f632491fbfffc941e32f1cf5a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "855a5d85fb6d3340c5c37caeb02d88aee2f7ff75a767f8d2b1ecb03e106b9a2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c43d4603e29943bd25456355635784fed7a7d927e4cabe1a545b2ab3a9873ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8b44a7dfa9836660b41ae2305400f77c27b86ce33e2aab18433368e881ad6cc"
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