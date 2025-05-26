class Readsb < Formula
  desc "ADS-B decoder swiss knife"
  homepage "https:github.comwiedehopfreadsb"
  url "https:github.comwiedehopfreadsbarchiverefstagsv3.14.1675.tar.gz"
  sha256 "4deb6b3294170f99d67c0ef6287d41674703aa75f8615ebc174171d48f59d143"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b67b4f511953d7d8187dd90588c5c82260a1833acf48b508576a776111b7d45"
    sha256 cellar: :any,                 arm64_sonoma:  "03954577a9ad2b62212c130219d4e02b6d2d666a6bb2fd3ccacded8aa36c459f"
    sha256 cellar: :any,                 arm64_ventura: "377f78cb2508d381f764357357d0864f8c186e5eb65b4da177f4f4df03be003b"
    sha256 cellar: :any,                 sonoma:        "7bed6fa867469ac88d0d5e68f14c61ffc457cd6855a816dd43f97cf7bdb9e5e2"
    sha256 cellar: :any,                 ventura:       "4ab18834c29bcf067b4e459e3a663a76623a7b8cefb5d915bf0a4394e6545f28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e3567cb5476187ca211d75e61e206562954b68e3217a04083da01afe035408e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c76846e21781cb22636344734d4337b63b9996e94f8d5da8a431ca7bb2f55f7"
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