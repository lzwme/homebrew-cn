class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdread/7.1.0/libdvdread-7.1.0.tar.xz"
  sha256 "0bab58b7fbbc22a4a8497435eda7c88c20ba5b575da22d1ee2c6842c16dae8ea"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://code.videolan.org/videolan/libdvdread.git", branch: "master"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libdvdread/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e139f2e30282e0153720bade5af862ac5c286e27df6ffc108045a33aa2e23c41"
    sha256 cellar: :any, arm64_sequoia: "67b9cc7387fc1212b90299867707a75dcafc5d73bef518ad8f39b1c3a9da0f55"
    sha256 cellar: :any, arm64_sonoma:  "c8e4e5d796e36159c84823edab8ecaa590f8631a5a83aab82cd3a954de98bb5d"
    sha256 cellar: :any, sonoma:        "ce301de4c4fb4c37e70712913c5e48a2647233a969c6b4aa4a4500f20dcb47aa"
    sha256               arm64_linux:   "3470e8ec6a5b69eac0ecfaff63c2907046291def79830b2cb16ef1d9b34a9b8d"
    sha256               x86_64_linux:  "43bd008be5f7fe570f36c3754d339bf779538a0919fc3c4462720ba506dcaba0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libdvdcss"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dvdread/version.h>
      #include <stdio.h>

      int main(int argc, char** argv) {
        printf("%s\\n", DVDREAD_VERSION_STRING);
        return 0;
      }
    C

    pkg_config_flags = shell_output("pkgconf --cflags --libs dvdread").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end