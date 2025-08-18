class Readsb < Formula
  desc "ADS-B decoder swiss knife"
  homepage "https://github.com/wiedehopf/readsb"
  url "https://ghfast.top/https://github.com/wiedehopf/readsb/archive/refs/tags/v3.14.1697.tar.gz"
  sha256 "1ce516e5fbb879e3c20ce214f896287a4937ef3a344ebfb3039fdeebef1ee082"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c798b28af6ce5422c0a8b165bdf5aa6866a95e0adb7277897da5dc872262c78"
    sha256 cellar: :any,                 arm64_sonoma:  "b33c70f5701b2733ba4a721712acc21dc36caa37c6c672f143282fcb0c85f4bb"
    sha256 cellar: :any,                 arm64_ventura: "7f94b60838b83fb48acacc4eb30bc06aeead0ea018a99f14a32677426903b326"
    sha256 cellar: :any,                 sonoma:        "eece485d2308b75ac68b3232c318791196cac35f53cc10fc5236e3e9220ad69d"
    sha256 cellar: :any,                 ventura:       "a37fd9a531ee0b0d6463e5f25f904758c2cc761df15110b8d30f6fef57a7bade"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8da70990cb9e57539375cc4dbbe0a1bbfdb81582b60505f07482316f4f5c588f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da6019d0c8bec11c55788852ff1b57982448ed363812b9dc043ced2a4547062f"
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