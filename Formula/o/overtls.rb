class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https:github.comShadowsocksR-Liveovertls"
  url "https:github.comShadowsocksR-Liveovertlsarchiverefstagsv0.2.30.tar.gz"
  sha256 "0902d37c9b7819cccf45f95442e2da53b32c47bdc929cea8c79dcfc52883aa3c"
  license "MIT"
  head "https:github.comShadowsocksR-Liveovertls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea5cd04657dcbba52043a9966e2ee3495b0098e66e9ef9b23b39dac3c2d997d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e35fdc47d770cfc2279a6a3ae8247b439b30627f0af788f28372da5c33f6f9ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b54fa246d473b29c0514d89f83f5a0d0f250a0776aa4511d93f3fd3fd1d4c85"
    sha256 cellar: :any_skip_relocation, sonoma:         "298046ea8821d35f786e7ad28febfd0ecdbbaf91308d7baa32cbee478c706dc6"
    sha256 cellar: :any_skip_relocation, ventura:        "3b7fd392eef0a9ec6b0e6d2cbe26e9426d3c9786985d7b11a5042498b9198898"
    sha256 cellar: :any_skip_relocation, monterey:       "b3a134d251613ddb8ad7b5490081dfc4406d53a4ecd6e5010d770bab34e459be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb4be0279d88a4dd97f92ffdef2f7a3c50c7d13471396ca2f9d110417aea316a"
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