class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https:github.comtun2proxytun2proxy"
  url "https:github.comtun2proxytun2proxyarchiverefstagsv0.7.10.tar.gz"
  sha256 "792b1267d47380289745dca1300d2e42a1c6f3f33af475a54031b0b56c4ff61c"
  license "MIT"
  head "https:github.comtun2proxytun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "195b50697e8e92c435c08da66593f6e18777f601f248051e335ba76fbe7cffbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53efedae49319528165c679f3329d350b261cfbc6ed51e42161a82d8ff63e54e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afee4c3fa6f79f052a595e4c5807eb7cb8820c649486e8a0c3cbe5e88a24fa73"
    sha256 cellar: :any_skip_relocation, sonoma:        "44429ff24fef093ebd55d1883664fb089d3a1e5e7e980e886cce095dee628eb2"
    sha256 cellar: :any_skip_relocation, ventura:       "ab638df3db3eb0e6fab929d9264395b9b5aa21101777852cddd9800e11ede89a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf7967b31c97ecfcbe5ef5353ad72504de3a991d195e645213350fe079cc6d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86ddcfa36fcc088f7f369f402cf46d43f1a4387dc62ef0fa69513c6728ca5992"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tun2proxy-bin --version")

    expected = if OS.mac?
      "Operation not permitted (os error 1)"
    else
      "No such file or directory (os error 2)"
    end

    assert_match expected, shell_output("#{bin}tun2proxy-bin --proxy socks5:127.0.0.1:1080 --tun utun4 2>&1", 1)
  end
end