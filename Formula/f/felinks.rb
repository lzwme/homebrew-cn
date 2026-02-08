class Felinks < Formula
  desc "Text mode browser and Gemini, NNTP, FTP, Gopher, Finger, and BitTorrent client"
  homepage "https://github.com/rkd77/elinks"
  url "https://ghfast.top/https://github.com/rkd77/elinks/releases/download/v0.19.1/elinks-0.19.1.tar.xz"
  sha256 "31960cd471246692b84008bffec89182f25818472f86ee1a41a09bf0dad09eeb"
  license "GPL-2.0-only"
  head "https://github.com/rkd77/elinks.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3d57c8348aac682ddcb98e982aa5476cdf8a96281993a8688d65baf0ae904cc1"
    sha256 cellar: :any, arm64_sequoia: "48930ba24682e85609abe97ee6ca7005a76a78517760320a3e9d44e7c5a0f142"
    sha256 cellar: :any, arm64_sonoma:  "5bd30b202e3b5f5bb740a0cf6320fd216812cbf1787e6eca785fe0b910f47ac4"
    sha256 cellar: :any, sonoma:        "30fba550985b987a34590fe68415e8a9b03f7288a5f2016f4fc09a5b635e2625"
    sha256               arm64_linux:   "a18fa0f9a5229b0623ffe965ce8d2a6aef0e555c90419c7919781ae10ee8f1c8"
    sha256               x86_64_linux:  "d8d17e66049123ffcd20fbdc085795ece4e0c90d5161b023dc433720f90997be"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "libcss"
  depends_on "libdom"
  depends_on "libidn2"
  depends_on "libwapcaplet"
  depends_on "openssl@3"
  depends_on "tre"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "python"
  uses_from_macos "zlib"

  def install
    args = %w[
      -D256-colors=true
      -D88-colors=true
      -Dbittorrent=true
      -Dbrotli=true
      -Dcgi=true
      -Dexmode=true
      -Dfinger=true
      -Dgemini=true
      -Dgnutls=false
      -Dgopher=true
      -Dgpm=false
      -Dhtml-highlight=true
      -Dnls=false
      -Dnntp=true
      -Dopenssl=true
      -Dperl=false
      -Dspidermonkey=false
      -Dtre=true
      -Dtrue-color=true
      -Dx=false
      -Dxterm=false
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.html").write <<~HTML
      <!DOCTYPE html>
      <title>Hello World!</title>
      Abracadabra
    HTML
    assert_match "Abracadabra", shell_output("#{bin}/elinks -dump test.html").chomp
  end
end