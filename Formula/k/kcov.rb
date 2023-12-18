class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https:simonkagstrom.github.iokcov"
  url "https:github.comSimonKagstromkcovarchiverefstagsv42.tar.gz"
  sha256 "2c47d75397af248bc387f60cdd79180763e1f88f3dd71c94bb52478f8e74a1f8"
  license "GPL-2.0-or-later"
  head "https:github.comSimonKagstromkcov.git", branch: "master"

  # We check the Git tags because, as of writing, the "latest" release on GitHub
  # is a prerelease version (`pre-v40`), so we can't rely on it being correct.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)*)$i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "476ce484dd142076f04dad5584324d7598b7ec364c03077c39487739d508702d"
    sha256 arm64_monterey: "bf315702b4328a6cd4acc2da03d867309af69a3d1a8fa418355a756300edae6d"
    sha256 ventura:        "9c25df1dfe0c2d36848105ad8339f39febc2880df838de7cb047ae4f437753bd"
    sha256 monterey:       "f2b4facad420ed243fd15a776ba46e4f2eb98769c0d95735a9840b3be1028c7d"
    sha256 x86_64_linux:   "c1b0c02c2c91e11096b2cdebaf1e388349e5d78ddd1922cff70aaf30899db411"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "dwarfutils"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
  end

  # Fix build on Big Sur, remove with next release
  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DSPECIFY_RPATH=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"hello.bash").write <<~EOS
      #!binbash
      echo "Hello, world!"
    EOS
    system "#{bin}kcov", testpath"out", testpath"hello.bash"
    assert_predicate testpath"outhello.bashcoverage.json", :exist?
  end
end
__END__
diff --git asrcenginesmach-engine.cc bsrcenginesmach-engine.cc
index ece8a1d..d9d475b 100644
--- asrcenginesmach-engine.cc
+++ bsrcenginesmach-engine.cc
@@ -26,7 +26,12 @@
 #include <set>
 #include <signal.h>
 #include <spawn.h>
+#include <syserrno.h>
+ clang-format off
+ sysptrace.h needs systypes.h, so make sure clang-format doesn't change the order
+#include <systypes.h>
 #include <sysptrace.h>
+ clang-format on
 #include <unistd.h>
 #include <unordered_map>
 #include <utils.hh>