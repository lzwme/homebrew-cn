class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://ghfast.top/https://github.com/nzbgetcom/nzbget/archive/refs/tags/v26.0.tar.gz"
  sha256 "9b683ce96d7a2e5e702a169e3fbfd16824cfe0ce8ed887c76cc25a574f69c9cd"
  license "GPL-2.0-or-later"
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01ec25a5c4703d854aaded258e2fb777d2f20a0282a45db6929442b570cd6c19"
    sha256 cellar: :any,                 arm64_sequoia: "ee93b4ba22524fa9155ab2d052c885e4ab42cda7e2d0c07245ee9fe68757908d"
    sha256 cellar: :any,                 arm64_sonoma:  "aee89ca3a7b8f4ba9a7232da66d2b021715f39178dd8415042cfc9b70ab5108f"
    sha256                               sonoma:        "27a640e5d51479adefa4390a9b2f4f701b7d3ccfc5172a124a56958ecdc21f80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce1e4e0933a2c3b44cca39a8b4c3623e3796ca8d3d87c9c6db4e4cc016261156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f387731a5b9f1b82455f38f4a72d432f2f277a6b6ca630fff629d59328ff2dd"
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