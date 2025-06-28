class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https:nzbget.com"
  url "https:github.comnzbgetcomnzbgetarchiverefstagsv25.1.tar.gz"
  sha256 "39f36d611879245f86d09f6a262f3be6c1c6adb6104cd4c174d0220574663307"
  license "GPL-2.0-or-later"
  head "https:github.comnzbgetcomnzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a0577a433ebe5f852bbf35cecf4353345846bfccd00f413d070f64d01b6b4230"
    sha256 cellar: :any,                 arm64_sonoma:  "f87dbafdef6acf28ef8c3b67a96742c08e9aa65681a31ba9362fa66b8f9a4cb7"
    sha256 cellar: :any,                 arm64_ventura: "02669b80ef87459826edb93c390aee51878b48ba1b71488450cbebd92439c12f"
    sha256                               sonoma:        "4f8d0e1a1e6cd326dfea10afa3ae08dd408a4a875a5239bda5cd1f42f581c93f"
    sha256                               ventura:       "4ed184814f4ce140817c98a2e8b505dd16c5309c644c1c1d31ab8bfd90b31fe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "743a63516fbe001c39f61d3cebe12401ad3e3fd4aa295168688094866a1a262a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82a6ee96096c10bd8b10626741876cc4d56edb79ec22cd5fdb00e343d1367958"
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