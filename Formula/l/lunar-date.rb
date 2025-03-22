class LunarDate < Formula
  desc "Chinese lunar date library"
  homepage "https:github.comyetistlunar-date"
  url "https:github.comyetistlunar-datereleasesdownloadv3.0.1lunar-date-3.0.1.tar.xz"
  sha256 "de00cf81fc7a31c08ea679c4a876dd6d4ea661b33bb8c192bbc016e8f3e16aca"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia:  "0edc08d00796351d91ad00136c32df5dacaaf76301cd9464ce2cb733ac976f91"
    sha256 arm64_sonoma:   "97f9d852239c52563215dcc32f17208dcdfc5c35abfa95ca71c04f7cb58257e9"
    sha256 arm64_ventura:  "19aff5df6a94c6367cefb6e970257d1533c6db1d7159f2ae8c1e0ec295ac9cbb"
    sha256 arm64_monterey: "01779a26cab511a07b5c288ada2ced6acedf252b1b58425f406068fc20e9aec7"
    sha256 arm64_big_sur:  "17475cd85977801b5ea3cb71e51329ed3ac322eb97c6109fd8c9d9addc44f07e"
    sha256 sonoma:         "9c788ea241de587d7c95023e558ca0bebc3366068287adb1de46d4ca1a5dcefb"
    sha256 ventura:        "f8990a85edb14b45e4819764856acd9dbb78960fc03557e40aacebdd23e8f1fb"
    sha256 monterey:       "fab352d50cf04dbb5f4048a7b2af595070bc0b45d0cfd0b5b9a23f39a875e523"
    sha256 big_sur:        "70f91a1f90710f781fdb99875b6e35d7b54f6be0b9e084ebab3ad6bd5b3a41a9"
    sha256 catalina:       "d1b8c963d4e48947c6d10aa04e18bd3775d117da648193c04f8207e77a606c62"
    sha256 arm64_linux:    "e80173e239b46806182a4ab44bc0d8996cf056e1bc28e0a582eace143cfc5c12"
    sha256 x86_64_linux:   "0fd076e291a5801cc977b8adc505e9cc279302bbedd4a62ba69166698c2166a6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    pkgshare.install "tests"

    # Fix missing #include <locale.h> in testing.c
    inreplace pkgshare"teststesting.c", "#include <stdlib.h>",
      "#include <stdlib.h>\n#include <locale.h>"
  end

  test do
    pkgconf_flags = Utils.safe_popen_read("pkgconf", "--cflags", "--libs", "lunar-date-3.0", "glib-2.0").chomp.split
    system ENV.cc, pkgshare"teststesting.c", *pkgconf_flags,
                   "-I#{include}lunar-date-3.0lunar-date",
                   "-L#{lib}", "-o", "testing"
    assert_match "End of date tests", shell_output("#{testpath}testing")
  end
end