class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.98.tar.bz2"
  sha256 "ce847313eaae9e5c9f21708e42d2ab7b56c7e0eb8803729a3092f58886d897e6"
  license :cannot_represent
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/download"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "86f372d66c76d8b580bce5fe115c5a7ff135b29432d6eb352e20a686754079e6"
    sha256 arm64_sonoma:  "6cab6232ad105f0fde0082fcde22fe3c77540a8f049108e781cce8c4daf03752"
    sha256 arm64_ventura: "b25f1cda59d8b0d400e3aba65ef00c3446e3c3b71783abbbd24aa16ef9c5a96e"
    sha256 sonoma:        "51d229c6515ddfbb501867c54aecde8f2bdb860059ef987f827869a532ec8bb4"
    sha256 ventura:       "5ab2842330fb3bf5e485beded2fbdde0a869557647903ea96a2c18b260cd2702"
    sha256 arm64_linux:   "0f6d1af6c67e23e2f318f85d55e5e110140464df7b31ce52af6a0c2bb3fd3145"
    sha256 x86_64_linux:  "59e03f71b2993561a93f7cc0604a6006ff89ba380e3f7237d866ee28b356cd2f"
  end

  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  conflicts_with "cern-ndiff", "ndiff", because: "both install `ndiff` binaries"
  conflicts_with "nping", because: "both install `nping` binaries"
  conflicts_with cask: "zenmap", because: "both install `nmap` binaries"

  def install
    # Fix to missing VERSION file
    # https://github.com/nmap/nmap/pull/3111
    mv "libpcap/VERSION.txt", "libpcap/VERSION"

    ENV.deparallelize

    libpcap_path = if OS.mac?
      MacOS.sdk_path/"usr/"
    else
      Formula["libpcap"].opt_prefix
    end

    args = %W[
      --with-liblua=#{Formula["lua"].opt_prefix}
      --with-libpcre=#{Formula["pcre2"].opt_prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --with-libpcap=#{libpcap_path}
      --without-nmap-update
      --disable-universal
      --without-zenmap
      --without-ndiff
    ]

    system "./configure", *args, *std_configure_args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    bin.glob("uninstall_*").map(&:unlink) # Users should use brew uninstall.
  end

  def caveats
    on_macos do
      <<~EOS
        If using `ndiff` returns an error about not being able to import the ndiff module, try:
          chmod go-w #{HOMEBREW_CELLAR}
      EOS
    end
  end

  test do
    system bin/"nmap", "-p80,443", "google.com"
  end
end