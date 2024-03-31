class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https:github.comShadowsocksR-Liveovertls"
  url "https:github.comShadowsocksR-Liveovertlsarchiverefstagsv0.2.19.tar.gz"
  sha256 "d7975311dcccc38fd19e53311f94d465fa95d4b0fe19e9fa190e3f335faec170"
  license "MIT"
  head "https:github.comShadowsocksR-Liveovertls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f0fa00c3c53fa201f4d1eef690a3bf2f9bf0eba89bd34f0961a613ea0d0ccb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa3ea4d2b635870e0b27957d7959436fa34ed8e1a3505fbdbcc55782742e094c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "884c33c799ddeff6d7efad0f91c026562751aa4267fbae2694515712b451af44"
    sha256 cellar: :any_skip_relocation, sonoma:         "851f222509280c796a9b0b1876a1ea719d3aaef93c4b0065cca96dacd4579bd5"
    sha256 cellar: :any_skip_relocation, ventura:        "888fbb8547ebe7a9e47c9d4c50614733bd3eec5084fdf332c0bc688c3628a76d"
    sha256 cellar: :any_skip_relocation, monterey:       "2c2c2ed68daea7c23eed7733724f13fec1b73b3acf5064ef0f072b6c05ed0000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80855d1b2c1d602ae4a4a0621d43e1a9bc891a1473aa1abc28f6084ad4664de2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}overtls -V")

    output = shell_output(bin"overtls -r client -c #{pkgshare}config.json 2>&1", 1)
    assert_match "kind: TimedOut, message: \"connection timed out\"", output
  end
end