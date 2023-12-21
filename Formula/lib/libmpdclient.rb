class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https:www.musicpd.orglibslibmpdclient"
  url "https:www.musicpd.orgdownloadlibmpdclient2libmpdclient-2.21.tar.xz"
  sha256 "286247c2cd5e99dba96ff3d207c3a723347a59be8321116cd30b685e2388d2be"
  license "BSD-3-Clause"
  head "https:github.comMusicPlayerDaemonlibmpdclient.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?libmpdclient[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f2224e406a3a6036c44a5a86b106adcf21986fd38ef6d8931449ae01652191de"
    sha256 cellar: :any,                 arm64_ventura:  "ee67efaddcee17ee4e5edd242b003d91fd5fdbbbb028343e42143c189c257e92"
    sha256 cellar: :any,                 arm64_monterey: "fe3034f298d1e967bac9e8c34788bf4f91a3b4142fc66de7e51943fa19346a2f"
    sha256 cellar: :any,                 sonoma:         "f935c4b437ece8482f5602a776fe4c187b7686cfe21bc7c292e6588b0fdbea3e"
    sha256 cellar: :any,                 ventura:        "845d9652dd9ddd348df4a9487f706303bacf60bb0ef481cc3d120400cd449c35"
    sha256 cellar: :any,                 monterey:       "1e0748370792f6e49b5970822c2ab01fbdcde80411017461984466c8eaa2c9e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9211e42d202349e1bc074a391f132cbc3cef8d0cf93a2e5a406f070176e73b3b"
  end

  depends_on "doxygen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", *std_meson_args, ".", "output"
    system "ninja", "-C", "output"
    system "ninja", "-C", "output", "install"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <mpdclient.h>
      int main() {
        mpd_connection_new(NULL, 0, 30000);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lmpdclient", "-o", "test"
    system ".test"
  end
end