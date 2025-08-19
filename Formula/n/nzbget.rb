class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://ghfast.top/https://github.com/nzbgetcom/nzbget/archive/refs/tags/v25.2.tar.gz"
  sha256 "a557d6067e551ee77fd86a9f395a8407438edc3ee16ab6797830db25ba8e1662"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cfc805d17f2dde8dc172b87ee538357606c927f1883c2375aba80215f9a1a39e"
    sha256 cellar: :any,                 arm64_sonoma:  "37f1781206860417b05ad5b3c32a4fdbbc4752275df7ab5203c0e06e37fd3991"
    sha256 cellar: :any,                 arm64_ventura: "f5b3c05a1de78f0c34fd45602518b44591482e6b799b28a0c8fc7c5749d51c82"
    sha256 cellar: :any,                 sonoma:        "9a06e612b01cb3cb97ba7d4d23e958138a471337f8923d925f816aa513b133b8"
    sha256 cellar: :any,                 ventura:       "3ef289e522618e695d05761fad0850c5c976589ad0f73a2dba5f773ac7f2b00b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d5757247006ceeefafe36fa98b76ce0c4813d5db6de7b189606c7fe43f5245e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b104a47939a6a6f9ee4a3e24de94941c656c69b21a6e1caced8d6a1e43c33bb7"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "sevenzip"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      # Set upstream's recommended values for file systems without
      # sparse-file support (e.g., HFS+); see Homebrew/homebrew-core#972
      inreplace "nzbget.conf", "DirectWrite=yes", "DirectWrite=no"
      inreplace "nzbget.conf", "ArticleCache=0", "ArticleCache=700"
      # Update 7z cmd to match homebrew binary
      inreplace "nzbget.conf", "SevenZipCmd=7z", "SevenZipCmd=7zz"
    end

    etc.install "nzbget.conf"
  end

  service do
    run [opt_bin/"nzbget", "-c", HOMEBREW_PREFIX/"etc/nzbget.conf", "-s", "-o", "OutputMode=Log",
         "-o", "ConfigTemplate=#{HOMEBREW_PREFIX}/share/nzbget/nzbget.conf",
         "-o", "WebDir=#{HOMEBREW_PREFIX}/share/nzbget/webui"]
    keep_alive true
    environment_variables PATH: "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin"
  end

  test do
    (testpath/"downloads/dst").mkpath
    # Start nzbget as a server in daemon-mode
    system bin/"nzbget", "-D", "-c", etc/"nzbget.conf"
    # Query server for version information
    system bin/"nzbget", "-V", "-c", etc/"nzbget.conf"
    # Shutdown server daemon
    system bin/"nzbget", "-Q", "-c", etc/"nzbget.conf"
  end
end