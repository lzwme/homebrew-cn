class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://ghproxy.com/https://github.com/Canop/dysk/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "ac744a595a742067403e76e6b47dea4ecda89880a636265ab6ca2cd0f128fcbf"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a5790eae48a6b66dd811301e209f694246612ecbff94e39857a1b5f73c8a3771"
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