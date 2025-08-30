class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://ghfast.top/https://github.com/Canop/dysk/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "dbf81a3f22282c6e9b3205b00c6e58e54d85e5ed163b1384076f4eb4aa4f5e0f"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "cb4dbe53d55835f0c424093e5cae7ce5dad518ea2b0ab985f7cb2dda482f3f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6ffd24f271b68440a0073e8c722c3110864a60e3101bf9c616184dbb240a3e8a"
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