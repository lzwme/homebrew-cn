class FoxgloveCli < Formula
  desc "Foxglove command-line tool"
  homepage "https://github.com/foxglove/foxglove-cli"
  url "https://ghfast.top/https://github.com/foxglove/foxglove-cli/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "e0119c482828d9b54702cbada860d35349aa362aa8ab97a0f7d977c20574d56c"
  license "MIT"
  head "https://github.com/foxglove/foxglove-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35c213ca9a637e182bae3a5bf7886e92bbb9cf2004986a6b7821232bc1b79458"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "49617aab6b2bd708e9a050befa7ba4c4366183c3ccabe38595c6a44099a3ebf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fb2ce3df792de3e533ca6bd96b95b6eeebe6ea0c0ab22b25d36d0347fd51ddc4"
    sha256 cellar: :any,                 arm64_linux:       "038eb6203d0ddb64c0343222dce8ea6dc52115dcbe0da5de4d491aa820b683e6"
    sha256 cellar: :any,                 x86_64_linux:      "0745aa7b4bf8a01ea9c69b036414ad23a93b5a89676a282c2eaa517cec1f5016"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    cd "rust" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    ENV["FOXGLOVE_VERSION"] = version.to_s
    cd "rust" do
      system "cargo", "install", *std_cargo_args
    end
    mv bin/"foxglove-rust", bin/"foxglove"
  end

  test do
    system bin/"foxglove", "auth", "configure-api-key", "--api-key", "foobar"
    expected = "Authenticated with API key"
    assert_match expected, shell_output("#{bin}/foxglove auth info")
    assert_match version.to_s, shell_output("#{bin}/foxglove version")
  end
end