class Readsb < Formula
  desc "ADS-B decoder swiss knife"
  homepage "https:github.comwiedehopfreadsb"
  url "https:github.comwiedehopfreadsbarchiverefstagsv3.14.1683.tar.gz"
  sha256 "4c56d0908719eaf6d1f1ea069798970b684db5c74e3661354dd0cea960ebd9d8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e922e1b214845fba9e41a85510c742253f3168dd1c05f29ca5d0ca942e8dcc6b"
    sha256 cellar: :any,                 arm64_sonoma:  "c53c28f79c1bc185b53551390aa47f413d80686b8b7bad3343eccb23ff6a2963"
    sha256 cellar: :any,                 arm64_ventura: "df6786c027075bc3f06c1d9a143648e8de062b62085f92f1046dba73f09e2198"
    sha256 cellar: :any,                 sonoma:        "5fece01277b304d3b69cb5d95198aa24a3a5c7a26039af3690089701e25b22fa"
    sha256 cellar: :any,                 ventura:       "2f9ab86cd9666a8aeaff6638c7942195ac7ba0d785593150b416564ce9fee21f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e899a9a5195e1a794d0dca523342a6fce70bf596f695aa3d9e0f7c54aae2d0ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c8af6ac11e21d9baf9b688e0988ecb0a21ad8dd52d732a69bc467ba6f140733"
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