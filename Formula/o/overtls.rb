class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://ghfast.top/https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.15.tar.gz"
  sha256 "9cb695a606a6fb58b91704a7c7c27a971019460ad9e0f31979839de61c13d614"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9bbb9c093c6fb2bb53cef2d75abb17177bf81a1962d99b8edb45c1183ba2486e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1755d05e0dbbee7561c5e3cf8ed14a67feb4ca492472bcd643b7f872af8f4cf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58f56be3850707a9fb414086c9e4f9c935f99e4b5159a8935fb9c8482845a505"
    sha256 cellar: :any,                 arm64_linux:       "f9ac842492366e040bff08e88d99371912b9088a70bd2d7f70fdb0be732c8708"
    sha256 cellar: :any,                 x86_64_linux:      "f1bc69ce66eb3c1ad2490b0c37edeb88f034f766774441358b1087daf709518b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output("#{bin}/overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end