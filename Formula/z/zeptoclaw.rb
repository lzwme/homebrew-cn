class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://ghfast.top/https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "31db246fad0edc33b9028b86052f7161b40821dc759b98c9251cb640b9ad260a"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f08030f3de6bf1a70a79770f823418287a9830f5a8731056c9f194bb389991e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "245ea5f7242f261e138100f1bcc7e1bf17c11c006285d7915245b7ca41c7bca8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bc07658c03d58d4bd8e175bf386636ebc3ac46aefbda52cf0d07762f48d1e20"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ed6cd33768a079e0b28b7444f52a3c1122d325af978e69ffc02c367573c98fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "014d5147b1107e0704f48a6f77249c0abd9615c8e2eded0ab9f67173290e0a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfa4c5d9f1b3540407a37cff8fd280346d08dae34e928c584f9411b4a2bb6c01"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end