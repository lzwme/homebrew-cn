class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://ghfast.top/https://github.com/gammu/gammu/releases/download/1.44.0/Gammu-1.44.0.tar.gz"
  sha256 "0f511812483f7e05143ffba568e30af4a3210a0cd53fe41abf4ed2c02ef99740"
  license "GPL-2.0-or-later"
  head "https://github.com/gammu/gammu.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "25f648c33ccf24574deb307e68c29995b7489c215592185f9092ce507e4f490a"
    sha256 arm64_sequoia: "a803e8a35a2dc9b464829eed033030028021ab7669a3d7aa12d43c28317e881c"
    sha256 arm64_sonoma:  "b345782fa58b97716a043ee35a57e295d4fc39eecde9c8f3ff24ad6609ae7fc3"
    sha256 sonoma:        "70205916795a6449b78024e024fcf7a8e3cdc40f2b82a83b49fe316a4e00d50c"
    sha256 arm64_linux:   "2c4ba294a224e3e6ebdf03574758f2397bc958494ab12a1fd6ff8acc2c79fc08"
    sha256 x86_64_linux:  "ec8d64bae9dd9de155b9fa92096bb477c51de3ce366d906c04ab8e21e1abb82e"
  end

  depends_on "cmake" => :build

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -DBASH_COMPLETION_COMPLETIONSDIR=#{bash_completion}
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_Postgres=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"gammu", "--help"
  end
end