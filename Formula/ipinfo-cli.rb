class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://ghproxy.com/https://github.com/ipinfo/cli/archive/ipinfo-3.0.0.tar.gz"
  sha256 "01bc040f85fe464bd2ce09f89804a09bb12d8883a89552996a50545f41e278c4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78bf681053cac6779fc1657df36c3b804d19358df1a83fe673dab5dca4d907e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9eeb8d7d8875b4d231ebe7d7201490e2de33bee2bc5482b886d52d10fd63e19b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "578cd3603590e453afb0d856bac7319d39e43e8d3665ddedf74153c6b5f34bce"
    sha256 cellar: :any_skip_relocation, ventura:        "76d1165137c583870c0a5af3dbe4e6856c340867c22ee4b465029bbc69654de7"
    sha256 cellar: :any_skip_relocation, monterey:       "45b23629ea5091c91c2c615a0c0635e6d3ec633ae7d997e2c3070b3c859c3872"
    sha256 cellar: :any_skip_relocation, big_sur:        "d584b4d68e9a430dc3bd0e9f1533b33ba1050973a7cbd2150f0211910a116e8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cf145b207fdc70cc72bbe57b036d746c694cd04a6917563883b20ec52408f57"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}/ipinfo prips 1.1.1.1/30`
  end
end