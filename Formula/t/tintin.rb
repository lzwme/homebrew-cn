class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://ghfast.top/https://github.com/scandum/tintin/releases/download/2.02.61/tintin-2.02.61.tar.gz"
  sha256 "640b4823b6f24ada6d417311bfd6263ab13be2422573c3b4ad4352223b535d88"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "703ec5ebcc98c21a3d5d6b07ac46a6f9fa873424a5c4d3bb72099a99d70ed74a"
    sha256 cellar: :any,                 arm64_sequoia: "45a2bd003f8af9e75652aa3eae618565b7d3855c64e27e959ce619503c50431d"
    sha256 cellar: :any,                 arm64_sonoma:  "29db49a2c0495ee7f69d736d1175dc1629f6910647cb82ffaee82d36e32912d1"
    sha256 cellar: :any,                 sonoma:        "0a26a3534747268cdb94ff00ca79f1bc82c60c4baf5511d339b58385bf70cabe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55c5da4c7f337551822f85be46322e99b3885db87d50df1ec4f3accdba33dea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be0a084d5f7c9bb8a0b273a4fd509c0ab115e5c8c7d1ffaa8e11911eae07149c"
  end

  depends_on "gnutls"
  depends_on "pcre2"

  uses_from_macos "zlib"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tt++ -V", 1)
  end
end