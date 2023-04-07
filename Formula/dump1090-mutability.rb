class Dump1090Mutability < Formula
  desc "ADS-B Ground Station System for RTL-SDR"
  homepage "https://packages.ubuntu.com/jammy/dump1090-mutability"
  url "http://archive.ubuntu.com/ubuntu/pool/universe/d/dump1090-mutability/dump1090-mutability_1.15~20180310.4a16df3+dfsg.orig.tar.gz"
  version "1.15~20180310.4a16df3+dfsg"
  sha256 "778f389508eccbce6c90d7f56cd01568fad2aaa5618cb5e7c41640a2473905a6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "65a2246aa5277b6eac0a934c32db640af72b39bdf4913788cea5711ff3f599a8"
    sha256 cellar: :any,                 arm64_monterey: "74d4061c93d647ace683380b85ab320e96b7e115a30ffe7587bc0c0672a097b5"
    sha256 cellar: :any,                 arm64_big_sur:  "53aa50bb97ebb0923c0ea340562f523e61018454bfcf78dcc6a6b5509aef6462"
    sha256 cellar: :any,                 ventura:        "bcdfc614e9496a402d75b7e4decb92704c7c9739fe8fff3f56cc3b1945184065"
    sha256 cellar: :any,                 monterey:       "7c2a4fc31ec409abf1ac74f68b65325f8d5ff38389b7f2be44b51d8529eeb338"
    sha256 cellar: :any,                 big_sur:        "331470e3b5efe1732916e5d6e5267dfee973d7be2c5573a4c6a9c2e8f207b1e9"
    sha256 cellar: :any,                 catalina:       "c2b702a7432ab1dd5086c693d4930103d2386782e43453fb7811a8d415505459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51cef04d99c6aeec12b2a1ae03cfcc84059d6fd0060026fc590ef93a3c172e91"
  end

  depends_on "pkg-config" => :build
  depends_on "librtlsdr"

  def install
    system "make"
    bin.install "dump1090"
    bin.install "view1090"
  end

  test do
    require "base64"
    enc="goB/en99g4B9gH6Eg35/fICVhJl/gXx9f4F+f36Af4B/f3+AgH9+f39/gH+Af4CBf4F/f3
    9/f3+AgIGAgH9/f4F/gX9/gH+Bf4B/f3+Af4F+f359gX5/f36BgYB9fIeGm46Ig3p+mIGYfX19f
    oGFf4B/gIGAf3+AgoR8dHVle3iBhH98fn6AgIB+gIB/gIF/f4F+gYCAf3+AfoB/fX6CgICAen6K
    i5WQhIF6foOBgYB9g454lW6CfH2Cg36AgYCBgX6Af4CAf4B/gICAf39/gICAf39/gICAf35/f4B
    /f35+fn6Af4B/f4B/gIB+f35+gX+BfoF/f39/fYF/fIGDgYF/aHttfISAgIB9gYGBfn6AgIF8fn
    6DlIaXgYF+fn+Df3+AgH+Cf4CAgH+Af4CAf4B+f4CAgH9+f39/foGCgH9xbG1wf4KDgHl/hIGCf
    mSIc4mYfJB9jHSUb4N+e36CgYCCfmp/a3p1cmh3dYGHf39+foCAfX9+gIF9cIddm2ybhIV/e3qZ
    gqyBkYiJjZSHipOJlYp9fIN+pn+ncol3eoGJd5lgjVt+eoCEe2V3aHt5Z2RfY3R8bntjen6BgYB
    hiFmZc46FeXuMd5x/iX+Siq2PmH17hoWUk42GkoGVgpF7k3yOd49wjnSGbIdrhHB8Z3xwfHBsWG
    Vlf4N/gGR4bXlwg2eIdoJpkFyfd417jHWdg4h+eYSal6qNkIyFk42PhZaAkYOOeplyhnl3fpBvm
    FeEYn6Ff3x4ZHlydnNjYmNwfIN/gGN9UYVli4CBfH1mk2OmeZmDfnuFhqaQpIaIjoyWkYF+f32d
    h6t7knV7got4lGmEd4hsi1CAaXx5dGR4dYOGcXFncn2CgoF7gH+Cf4F+f4CAf4GAgYF/gH+AgIB
    /f39/gIF+gH1/f3+Af4CAfoB+f39/gYB/fn5+gIB+fX5+gIJ+e4CCf4F+XYpcjnmGcJBxk4N9fI
    R7qIiphox+fIWLm52kkoh/fIGXgJd7iH2dbKBkhXaHb4tkfn1+gX1fa1VzcoeFdnhlc3R8bXxQh
    mOMg395hmySdo97knuTgI6CkYWTiZKKkJCKkYiPh5iBkn+Pfqhvn2t9gYB9jGaHcIBwfGZ/dHNp
    ZFpzc3N5Y3N3gYOAY39TkGuSgoB8f22ecqp8joKOhp5+hYF8kJOPjZKAlIeQg5d5kX6PeKJnlmy
    Bc4hshW18a4BrfXBwaXVzhIVxdVJvY311gGSGb4WFfHOMbZd7iXiYfa6Dk354hYqNloyKkIiRiJ
    J/k4CRfpVyj3mNdplbj2aAd4Njgm19hnlwdWdxd21zbnRufWw="
    plain = Base64.decode64(enc)
    (testpath/"input.bin").write plain
    result = <<~EOS
      *5d4d20237a55a6;
      CRC: 000000\nRSSI: -14.3 dBFS
      Score: 750\nTime: 206.33us
      DF:11 AA:4D2023 IID:0 CA:5
      All Call Reply
        ICAO Address:  4D2023 (Mode S / ADS-B)
        Air/Ground:    airborne
    EOS
    assert_equal result, shell_output("dump1090 --ifile input.bin 2>/dev/null").strip
  end
end