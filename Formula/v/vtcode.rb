class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.53.1.crate"
  sha256 "44b8824a3090e8c71918e83dc8ad2b454129371279600bb49c640828ac6baad1"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7f66dc14a5b87ec99e5530b2b3452358782a9ecc28cea2a3fc1c831d24cbf9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a8ad23475213e2af85edaa29e86604bcde87c4de9f74fd11b05d9feb8f9ded2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2caf7aec5099897f0aa44efb407a58bccdc13c7e09fda72347914f6628317b92"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee64901bb555cf97fdac48874a883914801422f8ececc44aaab0825a502d1d13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cde2b61d561a2d08542099451c4325579899d2571ffeccf41b071cf8234d6687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "531d97db2bd42652845ed9d3d7d3d5c42864f40ccdf6dae74d0096abae61eef5"
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