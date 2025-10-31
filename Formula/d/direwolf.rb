class Direwolf < Formula
  desc "Software \"soundcard\" AX.25 packet modem/TNC and APRS encoder/decoder"
  homepage "https://github.com/wb2osz/direwolf"
  url "https://ghfast.top/https://github.com/wb2osz/direwolf/archive/refs/tags/1.8.tar.gz"
  sha256 "20af50f397ce492a1e42889a1e2eba54581334c0754adae8e196433998a44e3a"
  license all_of: [
    "GPL-2.0-or-later",
    "ISC", # external/misc/{strlcpy.c,strlcat.c} (Linux)
    :cannot_represent, # external/geotranz, see https://github.com/externpro/geotranz/blob/v2.4.2/readme.txt
  ]
  head "https://github.com/wb2osz/direwolf.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "a5a1f073383e637adb447825393d588a0c1c0562a20c1899783da6eec80c17b5"
    sha256                               arm64_sequoia: "d8eee1f375cf3bbcbab59ca4cfda791fb9bea83badbd2386133a062f17d13084"
    sha256                               arm64_sonoma:  "2546b37fb83a5c0f35096547fc22bd4d5610700c0598a5c58297e162604be78f"
    sha256                               sonoma:        "042e43a3932fecd186791932f50e26a77bc8aa77efb85c6e214e85f219b95084"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc6687ae305f7c46779b16b57aa3846697dfcbe4a12ba70eac4afabc84931297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87cbcbcaa44059571a339bd152b9b3b011d9ad53c633e3ff5ace6cf5460cd9a2"
  end

  depends_on "cmake" => :build
  depends_on "gpsd"
  depends_on "hamlib"

  on_macos do
    depends_on "hidapi"
    depends_on "portaudio"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "systemd"
  end

  def install
    inreplace "src/symbols.c", "/opt/local/share", share
    inreplace "conf/CMakeLists.txt", " /usr/lib/udev/rules.d", " #{lib}/udev/rules.d"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "--build", "build", "--target", "install-conf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/direwolf -u")

    touch testpath/"direwolf.conf"
    assert_match "Pointless to continue without audio device.", shell_output("#{bin}/direwolf brew", 1)
  end
end