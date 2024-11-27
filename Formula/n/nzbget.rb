class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https:nzbget.com"
  url "https:github.comnzbgetcomnzbgetarchiverefstagsv24.4.tar.gz"
  sha256 "ea3ebe13f5d48f040f1614b62bff9b51da134f4f689ec918997f5896cf51f337"
  license "GPL-2.0-or-later"
  head "https:github.comnzbgetcomnzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0478991b7ae356aca4c35a7d036fdcb188988b57811fd2bb1a1d678e9dbc33fc"
    sha256 cellar: :any,                 arm64_sonoma:  "7af9e5cee1dabae64cd660cbe0fb9bde0aaf3607f80ee798d052483a436f5492"
    sha256 cellar: :any,                 arm64_ventura: "e353ce5f208b56a48f41656ee35784f74dabe71759e1f676f426f7b67d7694d1"
    sha256                               sonoma:        "d0ffe0849e5e2135a7405402a55b6787cfe546e7dac732024e1cd9b7737fb103"
    sha256                               ventura:       "df3636cf74641699384be7edf44b9d7126ec3fa9cf44b81812cfdada38bf3e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea5ef2b5e097844f99a180ccd6c2b9508354c1d8ecf0dcd228de3b71a69173ea"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "sevenzip"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "par2cmdline-turbo" do
    url "https:github.comnzbgetcompar2cmdline-turboarchiverefstagsv1.1.1-nzbget.tar.gz"
    sha256 "b471a76e6ac7384da87af9314826bc6d89ce879afb9485136b949cc5ce019ddf"
  end

  # Use the par2cmdline-turbo resource instead of fetching it
  patch :DATA

  def install
    # Workaround to fix build on Xcode 16. This was just ignored on older Xcode so no functional impact
    # Issue ref: https:github.comnzbgetcomnzbgetissues421
    if DevelopmentTools.clang_build_version >= 1600
      inreplace "libsources.cmake", 'set(NEON_CXXFLAGS "-mfpu=neon")', ""
    end

    resource("par2cmdline-turbo").stage buildpath"par2cmdline-turbo"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCURSES_INCLUDE_PATH=usrinclude"
    system "cmake", "--build", "build"

    # nzbget CMake build does not strip binary
    # must be removed in v25, tracking issue https:github.comnzbgetcomnzbgetissues257
    system "strip", "buildnzbget"

    system "cmake", "--install", "build"

    if OS.mac?
      # Set upstream's recommended values for file systems without
      # sparse-file support (e.g., HFS+); see Homebrewhomebrew-core#972
      inreplace "nzbget.conf", "DirectWrite=yes", "DirectWrite=no"
      inreplace "nzbget.conf", "ArticleCache=0", "ArticleCache=700"
      # Update 7z cmd to match homebrew binary
      inreplace "nzbget.conf", "SevenZipCmd=7z", "SevenZipCmd=7zz"
    end

    etc.install "nzbget.conf"
  end

  service do
    run [opt_bin"nzbget", "-c", HOMEBREW_PREFIX"etcnzbget.conf", "-s", "-o", "OutputMode=Log",
         "-o", "ConfigTemplate=#{HOMEBREW_PREFIX}sharenzbgetnzbget.conf",
         "-o", "WebDir=#{HOMEBREW_PREFIX}sharenzbgetwebui"]
    keep_alive true
    environment_variables PATH: "#{HOMEBREW_PREFIX}bin:usrbin:bin:usrsbin:sbin"
  end

  test do
    (testpath"downloadsdst").mkpath
    # Start nzbget as a server in daemon-mode
    system bin"nzbget", "-D", "-c", etc"nzbget.conf"
    # Query server for version information
    system bin"nzbget", "-V", "-c", etc"nzbget.conf"
    # Shutdown server daemon
    system bin"nzbget", "-Q", "-c", etc"nzbget.conf"
  end
end

__END__

diff --git acmakepar2-turbo.cmake bcmakepar2-turbo.cmake
index 8b92c12..cddb1b4 100644
--- acmakepar2-turbo.cmake
+++ bcmakepar2-turbo.cmake
@@ -1,17 +1,8 @@
-set(FETCHCONTENT_QUIET FALSE)
-FetchContent_Declare(
-	par2-turbo
-	GIT_REPOSITORY  https:github.comnzbgetcompar2cmdline-turbo.git
-	GIT_TAG         v1.1.1-nzbget
-	TLS_VERIFY	    TRUE
-	GIT_SHALLOW     TRUE
-	GIT_PROGRESS	TRUE
-)
-
 add_compile_definitions(HAVE_CONFIG_H PARPAR_ENABLE_HASHER_MD5CRC)
 set(BUILD_TOOL OFF CACHE BOOL "")
 set(BUILD_LIB ON CACHE BOOL "")
-FetchContent_MakeAvailable(par2-turbo)
+
+add_subdirectory(${CMAKE_SOURCE_DIR}par2cmdline-turbo)
 
 set(LIBS ${LIBS} par2-turbo gf16 hasher)
 set(INCLUDES ${INCLUDES} ${par2_SOURCE_DIR}include)