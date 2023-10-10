class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://ghproxy.com/https://github.com/Canop/dysk/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "467268304de9be070028cb90c979bc41b328b20ddc11aa6ec9648eda96e5db9a"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6043d6a5f450246f5aae060199568f3e2c01d260d87dd6b72cde3504f646ac30"
  end

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end