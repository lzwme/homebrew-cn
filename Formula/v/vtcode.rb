class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.48.0.crate"
  sha256 "f8348fde6fdee2e609d90e57390b2e3f53e5c1c2dc58053dcfe78621bca6d726"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21520273035c87fe57b6282e44db77b15cab1cb05bceecd526c757a2424913ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49313fac47407f793209691511cfcb1015db4ac7cbe00bf6aa4c85ebca3cc7fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe5329ec2cc33157be6b557dec344ae16aee7c7b309e57f970800cfe47b65ad8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b78439d3ecc26c184313978da4de19988dbb10e86f04bf7355cbe9ca2350d720"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee96b931b0d92bd20cab1a977278bdf9f51c4afa26a912c63ec4e0a92701de51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8404ec628fed7b4c657d332268b01b0b33c79b1767f25a7640943d43ff0609d5"
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