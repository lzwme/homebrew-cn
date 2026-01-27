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
    rebuild 3
    sha256 arm64_tahoe:   "95d7b75ae2a9da04351b2994468e82f78bf9573197ad5776a27b048a78eb2468"
    sha256 arm64_sequoia: "63813be2110cd230c604c14edd90b0b4ee2fa308ca352a8ffbe67fce7c1fc2b2"
    sha256 arm64_sonoma:  "0b51a232db73376b99e26615545935202c5a05a17545ad8d4c7b1e91de77dd0d"
    sha256 sonoma:        "6d2744e1823e5a07e7ca581e22eb4877a2503f8c3c8ea6d536d0623cc5e0fe99"
    sha256 arm64_linux:   "329df202cc658166431a55512ab80f6136a836dfe75f1f87dfbc3f5bbdf3bb4a"
    sha256 x86_64_linux:  "2abc96485fe00e61cbe83997d3e776e2f89e3ded33e731143daae0f0206e770a"
  end

  depends_on "python-setuptools" => :build
  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.14" # for ndiff

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  conflicts_with "cern-ndiff", "ndiff", because: "both install `ndiff` binaries"
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

    # Install `ndiff` separately so that we can use `pip` and `setuptools`.
    system "python3", "-m", "pip", "install", *std_pip_args, "./ndiff"
    bin.glob("uninstall_*").map(&:unlink) # Users should use brew uninstall.
  end

  test do
    system bin/"nmap", "-p80,443", "-oX", "scan1.xml", "google.com"
    cp "scan1.xml", "scan2.xml"
    system bin/"ndiff", "scan1.xml", "scan2.xml"
  end
end