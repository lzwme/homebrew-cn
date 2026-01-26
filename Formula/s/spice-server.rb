class SpiceServer < Formula
  desc "Implements the server side of the SPICE protocol"
  homepage "https://www.spice-space.org/"
  url "https://gitlab.freedesktop.org/-/project/62/uploads/54a0f9f5d1840e1ad8060cb560f3dde6/spice-0.16.0.tar.bz2"
  sha256 "0a6ec9528f05371261bbb2d46ff35e7b5c45ff89bb975a99af95a5f20ff4717d"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://gitlab.freedesktop.org/spice/spice.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c58bf2bae5cd9a5af25fdc41cf9a9bfbd7442c31d5c1aefb0beba267fc5bb2f9"
    sha256 cellar: :any,                 arm64_sequoia: "adfedc8beb6e4a6b1f13323ed4ad575cfd595612fb75f79de2d9a30aefa22284"
    sha256 cellar: :any,                 arm64_sonoma:  "0469cd892791f90ac5ac230507f617e988f8c7c9fccb9c05f09739bfa621ce9b"
    sha256 cellar: :any,                 sonoma:        "bc93d05ec9e1635aa6ad819e72cf268a85a3543309e6c7446b10f04f779624b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e26a5e2aeb72d322a637647810fd834945f3ae3c01edec503720b75812448076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf9d4dad6c0aa62a44e40689bac61082e8872c257b0c3ba70373e87f61b44497"
  end

  depends_on "spice-protocol" => [:build, :test]
  depends_on "pkgconf" => :test

  depends_on "glib"
  depends_on "gstreamer"
  depends_on "jpeg-turbo"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "orc"
  depends_on "pixman"

  uses_from_macos "cyrus-sasl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "systemd"
  end

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "spice.h"
      int main() {
          spice_compat_version_t current_compat_version = spice_get_current_compat_version();
          printf("Current compat version: %d\\n", current_compat_version);
          return 0;
      }
    C
    flags = shell_output("pkg-config --cflags --libs spice-server").chomp.split
    system ENV.cc, "test.c", *flags, "-o", "test"

    assert_match "Current compat version: 1", shell_output("./test")
  end
end