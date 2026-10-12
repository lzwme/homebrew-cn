class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://ghfast.top/https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.16.tar.gz"
  sha256 "77e799041391f94e8aefa33d29905e98d28eb200a6cf059518a7d9184f63775e"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19b241629092a81e0feece7d9a739bf5c33055ec3f1e781c1a348c5cf297def4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7d0aad45377a63e59ddc3c05f62add39cf3381483b7956d04118a470d61e177"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "02a3f7992d583bfa13b2a2b5dfdc423564f3916ff1178c094b863d8c68b48448"
    sha256 cellar: :any,                 arm64_linux:       "a21608252f94877e1b33571ae0da8edf01d15aca645c35ea65d504d6f912ba97"
    sha256 cellar: :any,                 x86_64_linux:      "f36ae8cc3f060080cbe496d6e42160dfc8bba40099bb738274611224f0b183ee"
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