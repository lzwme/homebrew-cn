class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://ghfast.top/https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.11.tar.gz"
  sha256 "f280e4aa992744ab33afd765fd48862869ff4145bd53e453a4e3f54866afc596"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abf37e58d552049daf5bc89c565eb954c9c8642a02e414708cd581b42f28eae5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ae442be5d07e3a8656662b422ef369ddace21222b68960fa6a423078ae638db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e610444dce26671e6a7c0b8f8b1ba883dd400a84a88b4512dac4d25d7e406d13"
    sha256 cellar: :any_skip_relocation, sonoma:        "b19cfedd9f5b6dc570b9d05c825ec6328a69361b070e3b999d31089dad0c6a49"
    sha256 cellar: :any,                 arm64_linux:   "29900cc75853efba2a0aeef98b632710bd8373635c3bfb054edb30c48982b6b6"
    sha256 cellar: :any,                 x86_64_linux:  "70b056878e7245a3f7d5a57be0fb8ed1b7385f9ff13b9ebfdd09ccab72b30788"
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