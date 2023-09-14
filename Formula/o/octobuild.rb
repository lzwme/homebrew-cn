class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://ghproxy.com/https://github.com/octobuild/octobuild/archive/refs/tags/0.7.1.tar.gz"
  sha256 "b7c2c505e7839d4f926b6e477cf379834928c4acafcab1f12a71cfe15727e3f4"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "604d188f5c52584eb86cba74edf13455408a9156de9e863e7573c8247300a94a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37d2f44ec6acbc223a15deac554c35b25d190bb604b6aabb4eb4e9cb86ff0920"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "314f7922102ea45c3f2b660676290b4d3e3fb8baaf4af37cb152347989d8f888"
    sha256 cellar: :any_skip_relocation, ventura:        "8cc374cfd4cfcb7ad63021c618479255956202c94ea35cb0bbabe668d5480a4a"
    sha256 cellar: :any_skip_relocation, monterey:       "196eac94ae29c6b750518d98a15754162e795bf5de322369c1f78808140fe996"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b3a469f4d49f6af4b75d2b73941915c835e3a78329455121622d7085abed67a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f765c432158966d29959b5f13f9f7cb97e5219716f7beef1ae7e98f16012fd5a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end