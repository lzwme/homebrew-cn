class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.42.0.tar.xz"
  sha256 "d8f152314d7e4d3d643610d742845e0a016ce97c234ad4b1151574e1b09651ee"
  license "GPL-2.0-or-later"
  head "https://github.com/gammu/gammu.git", branch: "master"

  livecheck do
    url "https://wammu.eu/download/gammu/"
    regex(/href=.*?gammu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sequoia:  "328d278f52762b77bb0bc0061afc898e413c2e8cbae9af19c0043ebd2b61ab5d"
    sha256 arm64_sonoma:   "69cbe22c74e7c7456df798bd70fe89c77502d7793f1b3073b0e0cc5f7d919323"
    sha256 arm64_ventura:  "d8aa4848b10f257303dc4e0e88e76fed841dfe127d4b560f8d3fff2b005ff7a0"
    sha256 arm64_monterey: "ec67090543b705c81803d19c3616cfa49db6bfb1d501df72ec754568a8b94a54"
    sha256 arm64_big_sur:  "d7a1bc97b049d30cd224c480d610f184e69672504b9159b591177723d5569f0a"
    sha256 sonoma:         "56c845f79c6f71c75a1931f4dece89db39e11132c0792eef6fd715e44bff1def"
    sha256 ventura:        "1844ae56290bf6ead655e43042e58d1358f12066e17827f5e7b6fe99f9008a2b"
    sha256 monterey:       "34e1a5844348815d60790601e23262901d64ef470f65da7187674a1ae0cc2a78"
    sha256 big_sur:        "4f9a5013aeefa5d20c9f1776c70685ab79572cc507f752672d0abc49b2b19ad7"
    sha256 catalina:       "c63e29ce190fb0beb5edbd3f0360eb7ce3694ee3144269608bdf2d56faef2b60"
    sha256 mojave:         "e972813fe9f1942b55c981ce75b21da479588912583ed52ed23da7c69f1f5d60"
    sha256 high_sierra:    "c0004802fb0a257197e96c4b7005a2ca63ca1d881c3b335d255b85f9e96d0124"
    sha256 arm64_linux:    "beb95870b00bd33a6c6712d3c8d8f8cb51c7fbc0df5c3550678880ec0ba65158"
    sha256 x86_64_linux:   "89adc4bf4ba892e03f2c55c0b892ee9da2116f43681f27b96a0398b531beac1e"
  end

  depends_on "cmake" => :build

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Disable opportunistic linking against Postgres
    inreplace "CMakeLists.txt", "macro_optional_find_package (Postgres)", ""

    system "cmake", "-S", ".", "-B", "build",
                    "-DBASH_COMPLETION_COMPLETIONSDIR=#{bash_completion}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"gammu", "--help"
  end
end