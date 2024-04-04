class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https:github.comShadowsocksR-Liveovertls"
  url "https:github.comShadowsocksR-Liveovertlsarchiverefstagsv0.2.20.tar.gz"
  sha256 "1be367e43ea8e58cd92c800488e70eaffb2d647aeb9ac8beed5c6f395a5c1a82"
  license "MIT"
  head "https:github.comShadowsocksR-Liveovertls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5ebb020553c775a28e773f16bc5602f3f2ed35684a8f8c14816ad70fc37af40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "618e1636aa92d9c69f3c8ba8bea40e5736d2543f0ac7222e8cb377ca4e604d56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43afad28b704c6c027e299ce8990e67baafe5d70814a735cb8765ab4199b3e59"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b6f7aea8612dd3084cf08a901076da598044cdc0c2b0a59307548cc1e3bef42"
    sha256 cellar: :any_skip_relocation, ventura:        "0e9ffee196962a16be446326e6d87a155b4931ffa2980da112c3a1da4002b968"
    sha256 cellar: :any_skip_relocation, monterey:       "3ccec72fbb194d2e216fe781bd970f87864d007b0086f5dadbbf18adea1d7c30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0811fc544f710f4e7da745eb59ad51d66fd000bb7ab686f232de977ecdd57da9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}overtls -V")

    output = shell_output(bin"overtls -r client -c #{pkgshare}config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end