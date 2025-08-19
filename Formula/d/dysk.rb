class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://ghfast.top/https://github.com/Canop/dysk/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "7270ac504db20f05f704459e76533755e26af0300c267a2a7b5db397102be803"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "28460b25dfcd3b4c91b57a3c3533efa2f4482ed4a021709f46e4e85566d66563"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d38cb8fb1e46360014f02bc86b96256257bd398c650a0a6fdcc68e434a870593"
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