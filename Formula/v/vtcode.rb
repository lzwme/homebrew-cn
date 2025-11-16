class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.44.1.crate"
  sha256 "ca614fb85e527194c64e7ec7ccac8dae8a9351fa4f2c320f45c957fd29e7c680"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "546ad1c640edc7229d1f6a9d24630433adbad5ddad29aaae931d2004915cb30b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2b7c7b4c658e8f4a9c2542139cb434f813143230d4284294f795df8b717ed9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "990ee4b48be3424cc412cc88a4bf3fd77636252a5f730857c01f973b2f29ebc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4b2e529f017f17e7646a93ec3408988892eb7a8286c1604f308ef77ae7a8833"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2c603604990dc4ccfd9b363ddd059d56c57cc2dfc66b6551db00a1df8c03c45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e274f9e616ac5308ce9fe92b6d781280e9b2c04876ff5569198f72bc7cc944a"
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