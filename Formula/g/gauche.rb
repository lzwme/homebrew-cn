class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https:practical-scheme.netgauche"
  url "https:github.comshirokGauchereleasesdownloadrelease0_9_14Gauche-0.9.14.tgz"
  sha256 "02928f8535cf83f23ed6097f1b07b1fdb487a5ad2cb81d8a34d5124d02db3d48"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(^\D*?(\d+(?:[._]\d+)+(?:[._-]?p\d+)?)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_sonoma:   "04592dfe5ce34a900e98cab2a165ea019c9d040c9dedf8381a67f86cb0e68e01"
    sha256 arm64_ventura:  "d4616d3eeb47eb9f0d14717aea03274dd0226946fa171acbee00445d45631c70"
    sha256 arm64_monterey: "46a69bae57af115c22ab25be694abf182f6751685cc3641ea600d21b3b075be3"
    sha256 sonoma:         "e1dad85e4e8422d54f8b984df724361d51c37b430a5863c9490e42ceacb9be72"
    sha256 ventura:        "eedceba1454dd4ab3439cd8a8cd00a99ee14be22c74cddfce6f18bf8f0edfc24"
    sha256 monterey:       "623c7186d3e6eaba14abe03d171ac9b42afbd186ff35cf20f3770b1f7e092e9b"
    sha256 x86_64_linux:   "a89d37c1913c8f068a1fc3e0489401b461480eac6c898b01cdcccf57cc23338a"
  end

  depends_on "ca-certificates"
  depends_on "mbedtls"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    system ".configure",
           *std_configure_args,
           "--enable-multibyte=utf-8",
           "--with-ca-bundle=#{HOMEBREW_PREFIX}shareca-certificatescacert.pem"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}gosh -V")
    assert_match "(version \"#{version}\")", output
    assert_match "(gauche.net.tls mbedtls)", output
  end
end