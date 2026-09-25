class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "428702395b6593268df073e7724a548fdc98be4a3cdf61656a6678e304a690a8"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e154a3606414c96095b045c66c5f6520aff5d21fe18508ca8b084e9a1e4712e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0c15483b4e1fdaa8f880c4ab283d9f46f930e123550a6f328dc552f852b101c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82377d183757b8fd39200eea6f09504b49a1e6e43dd2ed797677a0c0b811289a"
    sha256 cellar: :any,                 arm64_linux:       "5ba60f025b654c8ed3e696d6be3288a8517787088757b811b639299fe8506998"
    sha256 cellar: :any,                 x86_64_linux:      "d45bf5e56a294aff09a8828abe94a01bab80d79158544ec77c3a2125d37963ca"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end