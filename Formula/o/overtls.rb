class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://ghfast.top/https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "df6a8de5d69cfcedaeae2e2b3889aeba2e0e9b3a4e3b151e0974cf7ff20327c7"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a4e3b41fc876a00b455d11cc89cdcb7e57d32e1db07745978baf0687c823ebc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25ed4183ff451d2423620ec3bd7bf201e16f9dd6664e905f6fa1126695687074"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4628ee033982b7f86423e2f8a6c4256ce997c47cfcf727c2e86b01f9fc302844"
    sha256 cellar: :any_skip_relocation, sonoma:        "8389910d83f1fccb05f7922e10c20aa52211e40f4901a40f138304d67d8e8766"
    sha256 cellar: :any_skip_relocation, ventura:       "1981add8e5b0db13a2c45ef3109d7dd2b00075040f5b003869c55e719e56daeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30e6c597696fe00ad869ae6dc346352b01f36e69cdd8e182699eb31964f7c088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4564f4c1477adad82fa7e788f3489d6f71c4f616567d02e90fdb0a3a25f3398e"
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