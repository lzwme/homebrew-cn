class Readsb < Formula
  desc "ADS-B decoder swiss knife"
  homepage "https:github.comwiedehopfreadsb"
  url "https:github.comwiedehopfreadsbarchiverefstagsv3.14.1682.tar.gz"
  sha256 "180d652829c0bb13e1935f9ee4975b5f2c055281f113e5b0325e3444bd0f4685"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c5fa49116b7c87e42dd0032918325bd7bbd0d940dd2e73990968a28a4dba7cc"
    sha256 cellar: :any,                 arm64_sonoma:  "fdd3e5c6838fc7a66224f9c457d929b62ae8b5825a015dcef960eddcb7b4c1db"
    sha256 cellar: :any,                 arm64_ventura: "1854876b1a48e1226e50fdfa369547098bea94e6c1c31f7f27b77ca276130467"
    sha256 cellar: :any,                 sonoma:        "a3123c9e05f016d865308b7724ce9d6bf9941e3a576c2bc5a4b7a3cfc799691f"
    sha256 cellar: :any,                 ventura:       "1a171b804d92f3cf9a7d839b32c5d2f4e77334d5365ed83f1916e2afd9739a3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23f89fe2f22b76026c66322b9d185fe5b0e3a838545b0c68798d786cdd6044e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "214fd1e751f5972472eef7559e0c67327d870b1f5f9fc487be0a4030ec3f3fd0"
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