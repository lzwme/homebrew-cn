class Readsb < Formula
  desc "ADS-B decoder swiss knife"
  homepage "https://github.com/wiedehopf/readsb"
  url "https://ghfast.top/https://github.com/wiedehopf/readsb/archive/refs/tags/v3.14.1684.tar.gz"
  sha256 "19894fe0d0db93da4742b55788bf4744cf08751ca493e988e976d6c5585b5c73"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9312cd416e222b864537454758c812ece3782144c7fdf32edb278dc0a4a77883"
    sha256 cellar: :any,                 arm64_sonoma:  "287ac0fac293cc384934c1c0e4a4aacb74370c61db9a39da8cf3d00ddbbdbdf2"
    sha256 cellar: :any,                 arm64_ventura: "7029733377b0baeef1195c060390818b46fb3e72d902af4b3a020e07e01aa640"
    sha256 cellar: :any,                 sonoma:        "c1780a8358cf1fc0f490e452b0fb8c308ff7f7404ef454115f9c42e8b8e46fe0"
    sha256 cellar: :any,                 ventura:       "9d921f9880c2aceb6bc9004a9b4597d84149f7c14f3731756d4871e50a6c0b5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e3b250fbef3b7c08ea7b40194a388d9448796a6a71dd01ccd032552ed95b46d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ba6e484cce246d739e7b743b4281b1395e6081246e706789e70c0a8d4f81196"
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
      goB/en99g4B9gH6Eg35/fICVhJl/gXx9f4F+f36Af4B/f3+AgH9+f39/gH+Af4CBf4F/f3
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
      J/k4CRfpVyj3mNdplbj2aAd4Njgm19hnlwdWdxd21zbnRufWw=
    EOS

    (testpath/"input.bin").write Base64.decode64(enc)
    assert_match "ICAO Address:", shell_output("#{bin}/readsb --device-type ifile --ifile input.bin 2>/dev/null")
  end
end