class Readsb < Formula
  desc "ADS-B decoder swiss knife"
  homepage "https:github.comwiedehopfreadsb"
  url "https:github.comwiedehopfreadsbarchiverefstagsv3.14.1666.tar.gz"
  sha256 "395063fdc4ba70af14b5a782c230b94dd2bc7c19a6922c935ea8465ddaddc717"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d1f67cd0c0459876dfcb743c99453700972cd13ef1088e1eeabf14abaf34ce44"
    sha256 cellar: :any,                 arm64_sonoma:  "70b40217e78618eee3d290f2e973ef56ba55fb99ad8616b8b766284027e798f7"
    sha256 cellar: :any,                 arm64_ventura: "d2949c6a7e2375c46f7f9dbc4cd3d0b70caea24109d44d698433ec11d2fa1d69"
    sha256 cellar: :any,                 sonoma:        "0dbf2f65a48e0a6443cda320b14e9308e9af8a378d4e0d3fb0876cb969817c8e"
    sha256 cellar: :any,                 ventura:       "cc083e102cfa71c65f2f2ceb8c9ff0c4c8b34f2484674cda4f9f9eadb10b1b82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a22b4abedaee52459d0f9ed5b62fc5552d94035799ad88b05a7092074c88675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "040bcb76f64363160946bf9567ad296c1bf4120869d55f03d0fc93c9c7629275"
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