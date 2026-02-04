class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.75.0.crate"
  sha256 "ba5b4f291ff659dafeb4f6316770eaf71a8ad3f6fca236efc1708593e32830b3"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4edbcdab56c7054446b40798b0eff7f020c96e0e7b8f1f68aa5974103c000083"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa83b576f5e9a48c09a2900998290e80d5a067722b496fc2225f014326bd5aae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12e978112180058541355eb43d2c94ae9133f9aa4c506b5da0f638be45f73246"
    sha256 cellar: :any_skip_relocation, sonoma:        "c474abbb341f45fb011516170eb1fe9f136ec4a274cc285c6d5861d43f3a5978"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97e42cc0865fb6ba117826ccb7c25f0425900bb2a2e4b62ff570d5aa9f1d2191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27121d8a8804353fcd89fc2af4fce6e2373ad5008cab6e2a0f1d0fc13f265b09"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end