class Readsb < Formula
  desc "ADS-B decoder swiss knife"
  homepage "https://github.com/wiedehopf/readsb"
  url "https://ghfast.top/https://github.com/wiedehopf/readsb/archive/refs/tags/v3.14.1693.tar.gz"
  sha256 "b80b467995ef39739389b45136786c37e5822327cf50e82f15a05c9e4c18ef18"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1437b9c866e3f399d395836c9523e3d219d6f93bd50e756f36e18b919802b118"
    sha256 cellar: :any,                 arm64_sonoma:  "4b38d3fa29723c75099ff54b4dbca9bc35591ad6d2f76ea9ca01db9c2c1e7a48"
    sha256 cellar: :any,                 arm64_ventura: "c0c6c4e4f4b396e14b167a8ac362506dcb5c416e8b4dd4e2911d4708a3009e43"
    sha256 cellar: :any,                 sonoma:        "e2b8ae37b083a1162c113af884326df884af0f4c3bd75352553c65eb9139c88e"
    sha256 cellar: :any,                 ventura:       "f3ebfc252a05b5251acafaf7afa6b642a24674207509154e834d60731f37462d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf6ec3b30a240f559f4ce73f667217bf77f8764e0dd6a89a1a75a22c3414aba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b49a7bb2f345710d7d1ee59202107ca124cbdb6a8951301c20f52941307de82e"
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