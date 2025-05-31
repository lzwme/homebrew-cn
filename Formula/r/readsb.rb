class Readsb < Formula
  desc "ADS-B decoder swiss knife"
  homepage "https:github.comwiedehopfreadsb"
  url "https:github.comwiedehopfreadsbarchiverefstagsv3.14.1680.tar.gz"
  sha256 "baa69ef8124548857d6da3b3cf976a43aba7860f4c60a0d9b256ea8c0cd93838"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "089c853a37f4e70575453b064d4acd69de59d1e806f72f8181221a76af40598a"
    sha256 cellar: :any,                 arm64_sonoma:  "606480a1e4b5003b68992ed5f55bbec1e1059738f548aa4ec5217fa2add43a26"
    sha256 cellar: :any,                 arm64_ventura: "8482388f79a773d07106eb7b2c24cc8bffae1a57fadb5c3b9cd5a2201c751335"
    sha256 cellar: :any,                 sonoma:        "d88fd656a45f291899cb89e42552673ca12e57568e511ed11ba5d9af73918c3c"
    sha256 cellar: :any,                 ventura:       "a9f68bd5022d60738908b8d125b521208785c69277fe2bba3d5f60dcaf12f129"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7575d97f40072c24c4c721398a36fb4e686afbc9bff1c097599c801e295fa45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0359384386786fe2cd5b4fd7089b088f020412bd634869e251fa29479355007d"
  end

  depends_on "pkgconf" => :build
  depends_on "librtlsdr"
  depends_on "zstd"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libusb"
  end

  def install
    ENV["RTLSDR"] = "yes"
    system "make"
    bin.install "readsb"
  end

  test do
    require "base64"

    enc = <<~EOS
      goBen99g4B9gH6Eg35fICVhJlgXx9f4F+f36Af4Bf3+AgH9+f39gH+Af4CBf4Ff3
      9f3+AgIGAgH9f4FgX9gH+Bf4Bf3+Af4F+f359gX5f36BgYB9fIeGm46Ig3p+mIGYfX19f
      oGFf4BgIGAf3+AgoR8dHVle3iBhH98fn6AgIB+gIBgIFf4F+gYCAf3+AfoBfX6CgICAen6K
      i5WQhIF6foOBgYB9g454lW6CfH2Cg36AgYCBgX6Af4CAf4BgICAf39gICAf39gICAf35f4B
      f35+fn6Af4Bf4BgIB+f35+gX+BfoFf39fYFfIGDgYFaHttfISAgIB9gYGBfn6AgIF8fn
      6DlIaXgYF+fn+Df3+AgH+Cf4CAgH+Af4CAf4B+f4CAgH9+f39foGCgH9xbG1wf4KDgHlhIGCf
      mSIc4mYfJB9jHSUb4N+e36CgYCCfmpa3p1cmh3dYGHf39+foCAfX9+gIF9cIddm2ybhIVe3qZ
      gqyBkYiJjZSHipOJlYp9fIN+pn+ncol3eoGJd5lgjVt+eoCEe2V3aHt5Z2RfY3R8bntjen6BgYB
      hiFmZc46FeXuMd5xiX+Siq2PmH17hoWUk42GkoGVgpF7k3yOd49wjnSGbIdrhHB8Z3xwfHBsWG
      Vlf4NgGR4bXlwg2eIdoJpkFyfd417jHWdg4h+eYSal6qNkIyFk42PhZaAkYOOeplyhnl3fpBvm
      FeEYn6Ff3x4ZHlydnNjYmNwfINgGN9UYVli4CBfH1mk2OmeZmDfnuFhqaQpIaIjoyWkYF+f32d
      h6t7knV7got4lGmEd4hsi1CAaXx5dGR4dYOGcXFncn2CgoF7gH+Cf4F+f4CAf4GAgYFgH+AgIB
      f39gIF+gH1f3+Af4CAfoB+f39gYBfn5+gIB+fX5+gIJ+e4CCf4F+XYpcjnmGcJBxk4N9fI
      R7qIiphox+fIWLm52kkohfIGXgJd7iH2dbKBkhXaHb4tkfn1+gX1fa1VzcoeFdnhlc3R8bXxQh
      mOMg395hmySdo97knuTgI6CkYWTiZKKkJCKkYiPh5iBkn+Pfqhvn2t9gYB9jGaHcIBwfGZdHNp
      ZFpzc3N5Y3N3gYOAY39TkGuSgoB8f22ecqp8joKOhp5+hYF8kJOPjZKAlIeQg5d5kX6PeKJnlmy
      Bc4hshW18a4BrfXBwaXVzhIVxdVJvY311gGSGb4WFfHOMbZd7iXiYfa6Dk354hYqNloyKkIiRiJ
      Jk4CRfpVyj3mNdplbj2aAd4Njgm19hnlwdWdxd21zbnRufWw=
    EOS

    (testpath"input.bin").write Base64.decode64(enc)
    assert_match "ICAO Address:", shell_output("#{bin}readsb --device-type ifile --ifile input.bin 2>devnull")
  end
end