class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.43.11.crate"
  sha256 "048e37c3f35611973b88259a1d9eb3ec122e333ede74ddf8894691a7fb96004a"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ba63194efb4abad79384e053e67deb28ba6862fe402cbd28eb999abbf8799ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c18345a39450509d2cdb023734988b11cf0104f00524f8e152868470e3c74151"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e19cfd01744c3ddafce28ede1bf7369c1475ae63e526482036a771e31f2294ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "864a2038ee6a20b5bbf03ff23268a9a5fa1add494d0316e8fd5e688690d83b56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cfc317e27be421abaa8f3e00895bd3b1feb3890951545dce07e1636ebe1c73c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "102fc126ead6d9e62913542c9ec2a4f147cb637c5e5b1a6da39453dfda738e16"
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