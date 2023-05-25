class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%203.0/bittwist-macos-3.0.tar.gz"
  sha256 "d5d0d5fdd30de76822d8eb36964783fb33ad2ba703879aad8a6634d773a9350d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5da7de7879a74aa16b50544cb077da092f3c36ae6d7c2ef1469716664cba88a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10c434ad8cae176e1e3ef12213da51024bbdd7009236be1b54d75ad72ea94bec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9e3ba140bfb33503e224b67bb1fddfbf2f967549323b85857ea677a59fecf04"
    sha256 cellar: :any_skip_relocation, ventura:        "cb79cd4fcae94326ecdd8191c9681ac6ede34f0df02f602dd5018fd1b345c04d"
    sha256 cellar: :any_skip_relocation, monterey:       "5a3667296896c09123f2c88d4c94691aa168616e2824ba67a3c89c1e2c32c0fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "9668892c38a0f943c77eabc0c49cba2e23696b4d9f6b642a98a95f6f0bc8133a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29e30b5465dd2ed11b08c4776ddeb312114da7dd8ffe4bfecddd2273ae20c305"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/bittwist", "-help"
    system "#{bin}/bittwiste", "-help"
  end
end