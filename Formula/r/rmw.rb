class Rmw < Formula
  desc "Trashcanrecycle bin utility for the command-line"
  homepage "https:theimpossibleastronaut.github.iormw-website"
  license "GPL-3.0-or-later"
  revision 1
  head "https:github.comtheimpossibleastronautrmw.git", branch: "master"

  stable do
    url "https:github.comtheimpossibleastronautrmwreleasesdownloadv0.9.1rmw-0.9.1.tar.xz"
    sha256 "9a7b93e8530a0ffcd49f1a880e0a717b3112d0ec1773db7349bac416ee1a42b3"

    # canfigger 0.3.0 build patch, remove in next release
    patch do
      url "https:github.comtheimpossibleastronautrmwcommit295185e3b8c1090ea01e9a817d56706847292118.patch?full_index=1"
      sha256 "dffc9c4a58b3043f3df0750dc7f935c3e4074f7a6445c057a013cda64b01ff84"
    end
    patch :DATA
    patch do
      url "https:github.comtheimpossibleastronautrmwcommitcdee62512a750ca3ccf6a2cb3ea12221036c22b9.patch?full_index=1"
      sha256 "0cf20084686966abafeef732acac7fbf82e286bcb21ada95e0aec8c447dc3948"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:[.-]\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "c0e89aca645212743b6fd4799b917408a8c30987822e8380a2f2880695648fb8"
    sha256 arm64_ventura:  "8ecc517cbf5ddf44d049bc5630adf389420f90ac59c2cc8a06d6810c3a26d74a"
    sha256 arm64_monterey: "08ce5fa8360cbc3c915094a11ba5ec9cd02204087d18a98014f3ae22c5c91575"
    sha256 sonoma:         "8f8b5b0acdd67752e0a88937cd298cb09dc9a344add9cd20e5ebece1d252f281"
    sha256 ventura:        "637dacc6362f285d7b526762562140c4e1c242c7529e9590430da85602457a61"
    sha256 monterey:       "9e5f6ef50ff462583f2f3e63536ea9a824ce5163b8202d9440a02b7d7b3b9ee1"
    sha256 x86_64_linux:   "e9453c9cef96e81a58479a72c3356642cfde1366cc8e839efdc71b579f10ad7b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "canfigger"
  depends_on "gettext"
  # Slightly buggy with system ncurses
  # https:github.comtheimpossibleastronautrmwissues205
  depends_on "ncurses"

  def install
    system "meson", "setup", "build", "-Db_sanitize=none", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    file = testpath"foo"
    touch file
    assert_match "removed", shell_output("#{bin}rmw #{file}")
    refute_predicate file, :exist?
    system "#{bin}rmw", "-u"
    assert_predicate file, :exist?
    assert_match ".localshareWaste", shell_output("#{bin}rmw -l")
    assert_match "purging is disabled", shell_output("#{bin}rmw -vvg")
  end
end

__END__
diff --git ameson.build bmeson.build
index 793322e..3ff2020 100644
--- ameson.build
+++ bmeson.build
@@ -63,7 +63,7 @@ config_h = configure_file(output : 'config.h', configuration : conf)
 main_bin = executable(
   'rmw',
   'srcmain.c',
-  dependencies: [dep_canfigger, dep_rmw, dep_intl],
+  dependencies: [canfigger_dep, dep_rmw, dep_intl],
   install : true
   )

diff --git atestmeson.build btestmeson.build
index ee982de..b1f0f39 100644
--- atestmeson.build
+++ btestmeson.build
@@ -23,7 +23,7 @@ foreach case : test_cases
     'test_' + case,
     '..src' + case + '.c',
     c_args : ['-DTEST_LIB', '-DRMW_FAKE_HOME="@0@"'.format(RMW_FAKE_HOME)],
-    dependencies: [dep_canfigger, dep_rmw]
+    dependencies: [canfigger_dep, dep_rmw]
     )
   test('test_' + case, exe)
 endforeach