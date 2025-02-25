class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https:nzbget.com"
  url "https:github.comnzbgetcomnzbgetarchiverefstagsv24.6.tar.gz"
  sha256 "93626dff2e725a1f1d99d14377826b264c7ae500559c6ad29d7cdd3c6d2dc6a3"
  license "GPL-2.0-or-later"
  head "https:github.comnzbgetcomnzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b61cb20345b1fb54b98edd863b48b47da5f906b4cbff3486352296af0f57ba8"
    sha256 cellar: :any,                 arm64_sonoma:  "5b736189675da556ea77485bf2b12f1c2b80e1399a596880ffc52ea7a24d2c3c"
    sha256 cellar: :any,                 arm64_ventura: "df109ed7741f8148f8cda7a6d61d0d1c05677237ac25bc00fdd1b5b2e0596450"
    sha256                               sonoma:        "1251b23e8d642da652e285d4d021f436361ae574da4c089f01a232b588190fdc"
    sha256                               ventura:       "80d686d49febbe498c90beae74e82f572050d07c816206fa769ad934437183d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccde90d75fdbe04df2ab283f0df4cac588d282fc8d37b136460d1ae804110f34"
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