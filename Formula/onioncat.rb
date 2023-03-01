class Onioncat < Formula
  desc "VPN-adapter that provides location privacy using Tor or I2P"
  homepage "https://www.onioncat.org"
  url "https://ghproxy.com/https://github.com/rahra/onioncat/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "4b73566fa44038584bb458faee002b72aabc250b6975ae01d4efbb8de4db3a15"
  license "GPL-3.0-only"
  head "https://github.com/rahra/onioncat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e6c123df954d5c78e62a82d846f54f5cf0be41c92540489ab7e60cb91c24cbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7c31f0b1a06f658193237bd0e39c111eab5d4f9576dc7994b52f8a77c43ab29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85b3f6e04f2e5d71e1b806fbca8a6a840ad4692213cf5fc7dab714ba75a2a89d"
    sha256 cellar: :any_skip_relocation, ventura:        "825df40f45067cf347d696631dede86fd2ef895245282544052b93fee9de0c22"
    sha256 cellar: :any_skip_relocation, monterey:       "ae9055e77589f86621f686b3e243150b95be340dece26c203c38291ed1929270"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7c0705c39509d327c5015695b200dc3bfb153566854426be0836074fc980bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "519b2c32d2464693c136295c8c6261530a0f07835275ddeacda857f1240033ea"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "tor"

  def install
    system "autoreconf", "-ifv"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"ocat", "-i", "fncuwbiisyh6ak3i.onion" # convert keybase's address to IPv6 address format
  end
end