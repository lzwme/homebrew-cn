class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https:nzbget.com"
  url "https:github.comnzbgetcomnzbgetarchiverefstagsv24.3.tar.gz"
  sha256 "b20ff0da1367825fbf00337a48196e81514195748d3d96f620f28ab2cc0b7cc0"
  license "GPL-2.0-or-later"
  head "https:github.comnzbgetcomnzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6c68cbbdab136141537374b155de26b72e32e2f0cde6139a2480d97a3cbdb5e0"
    sha256 cellar: :any,                 arm64_sonoma:   "5c8c7d15f27dc7b650f42e049c29111af248e35dfb41916939869c9d63f1f986"
    sha256 cellar: :any,                 arm64_ventura:  "5d1ca334ae08f0aaf99c474b3d6ca01d7a24ce6e34a25ef84426bd829e2bae0d"
    sha256 cellar: :any,                 arm64_monterey: "fe3f2f00177bb08ab060af9524068489e3fde33fcd1262d2099eca47234ae8a8"
    sha256                               sonoma:         "8735a21091a5d22fd9faf0571b02c003825022a4bccb17b25d361314961bb24a"
    sha256                               ventura:        "648677c0bd4dd2b93e3737c4ebb11fe9e5f6f6dc591da8f3df75a5e4d055f23a"
    sha256                               monterey:       "cc815d9546026e20294ac1690eba95d1329db0cc74ecc4015cc48484d3371b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5658154d9bdc1496d74858305c9c72284efe6639c1252e827519c147d5b0dc3"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "sevenzip"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Workaround to fix build on Xcode 16. This was just ignored on older Xcode so no functional impact
    # Issue ref: https:github.comnzbgetcomnzbgetissues421
    if DevelopmentTools.clang_build_version >= 1600
      inreplace "libsources.cmake", 'set(NEON_CXXFLAGS "-mfpu=neon")', ""
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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