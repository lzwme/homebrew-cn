class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.991.tar.bz2"
  sha256 "a5d507f29437bef3bedd4771ff9aaa8fc1c2a109ddba1f5b1cf12027456929be"
  license :cannot_represent
  revision 1
  compatibility_version 1
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/download"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "300582ff9816078b46ee25141fe88840a76228dedd4a0b15b32081ef4165bc66"
    sha256 arm64_tahoe:       "dd43dd9335ff2b6ecc25398155fda5c657b74a307c57e226fb9207f53739829e"
    sha256 arm64_sequoia:     "5c2bd58115e740dfd308474e6d6ab769d119ef5287ab04ae5252f9512264a68f"
    sha256 arm64_linux:       "680031f7ef3264df3c587c03df3690e0380feff16fa387171b3793267d8ba12f"
    sha256 x86_64_linux:      "85107b6aad9b643ee32c4d78c8932511caefe90cd6a50bdf32be43bde71cb80d"
  end

  depends_on "python-setuptools" => :build
  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "python@3.15" # for ndiff

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "cern-ndiff", "ndiff", because: "both install `ndiff` binaries"

  # needs a network connection to test
  allow_network_access! :test

  def install
    # Fix to missing VERSION file
    # https://github.com/nmap/nmap/pull/3111
    mv "libpcap/VERSION.txt", "libpcap/VERSION"

    ENV.deparallelize

    libpcap_path = OS.mac? ? MacOS.sdk_path/"usr/" : formula_opt_prefix("libpcap")

    args = %W[
      --with-liblua=#{formula_opt_prefix("lua")}
      --with-libpcre=#{formula_opt_prefix("pcre2")}
      --with-openssl=#{formula_opt_prefix("openssl@4")}
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
    system python3, "-m", "pip", "install", *std_pip_args, "./ndiff"
    bin.glob("uninstall_*").map(&:unlink) # Users should use brew uninstall.
  end

  test do
    system bin/"nmap", "-p80,443", "-oX", "scan1.xml", "google.com"
    cp "scan1.xml", "scan2.xml"
    system bin/"ndiff", "scan1.xml", "scan2.xml"
  end
end