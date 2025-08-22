class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://ghfast.top/https://github.com/nzbgetcom/nzbget/archive/refs/tags/v25.2.tar.gz"
  sha256 "a557d6067e551ee77fd86a9f395a8407438edc3ee16ab6797830db25ba8e1662"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "02a229d242fc3773175fc982ce8640bf8e246365612d6c338860b75d0bf4a862"
    sha256 cellar: :any,                 arm64_sonoma:  "9186bb19216c710bc385133fc2eb04f8e18ba66ab08d86b86e21090bdadef0ab"
    sha256 cellar: :any,                 arm64_ventura: "4b14901c229483845a2806f26dec7c7096fe6a4cc20e322104b781b685b6868b"
    sha256                               sonoma:        "69a85d8797a5dc8f39ca9e941d029a46c019e8344df9ecd9e918fda71545b610"
    sha256                               ventura:       "6c022461281e67314ae48698640a521a506a3d48ac0e3a365d0447ac685f284b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b735d3fe4b3b0dca41b27f1aca6762ef95724797c5e1071efc5ec99c845140e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "641346d6c0167846bec3f3eebe62e16407a963408644599bf1d6d515e8256048"
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

    inreplace "nzbget.conf" do |s|
      if OS.mac?
        # Set upstream's recommended values for file systems without
        # sparse-file support (e.g., HFS+); see Homebrew/homebrew-core#972
        s.gsub! "DirectWrite=yes", "DirectWrite=no"
        s.gsub! "ArticleCache=0", "ArticleCache=700"
      end

      # Update 7z cmd to match homebrew binary
      s.gsub! "SevenZipCmd=7z", "SevenZipCmd=7zz"
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