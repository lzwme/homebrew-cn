class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https:nzbget.com"
  url "https:github.comnzbgetcomnzbgetarchiverefstagsv24.2.tar.gz"
  sha256 "4fbcfc4faa49be0dc9d0b85cfbae2e38043be1e2f6755e6891d48785baa9438b"
  license "GPL-2.0-or-later"
  head "https:github.comnzbgetcomnzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5a96e1b17b202d54fa97ebe5fd4f1d38550d4e8a285c60fbb465ee9be009ab77"
    sha256 cellar: :any,                 arm64_ventura:  "cf6d8e282f4248416118d56204cfe6d49e8bec7cb09886d33f35f7d44fedc22d"
    sha256 cellar: :any,                 arm64_monterey: "d53efce230b7a7fc9747ce1a608b3badae5a10c9b49024a3d9437d1e552c9fbe"
    sha256                               sonoma:         "9559272a9e37f378ceca3b761ba31899b026a01d4ac710754fd50dc25cb498f0"
    sha256                               ventura:        "252c8037f8e7415f1d0f44dca59775b81a69fe9c0ac71299c6de472efd5b0a72"
    sha256                               monterey:       "e6bac6b68919d792c280e9bd4c65f98553178e2290b678d45d657bb01f3fb554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8a237114ad39707e20f453b6c69832808b834919c54babd318842ba4b1c07a9"
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