class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.43.4.crate"
  sha256 "146c150febfc4918d400acea0be7ca0ec2b3a78d96a3c0a37042407d2acad901"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01a59e8ce8b0dad96f17ab9cbf918faa5528f86397cfca1912085826ccead564"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb8c623cdd60cf802de54f17038f75b8d093b24421427a806290f54dbdf6165f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e73f2026d92c47dedcc78423aa4aacd7f3e9229cf7c4634232a9f27fa739288"
    sha256 cellar: :any_skip_relocation, sonoma:        "07c4cc72ebbfc39a9b1e24cbb710f3339bf83cf8aa5fdd9aa2cd107d1986a1e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8426206ade0d17b40402b764c4d2bb63eb30faf0533bd4ff9dee467035edaeb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f17c63a456a68d0d88defd34b1b3b543053a2c303df74f0767b8e015979f739"
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