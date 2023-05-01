class Felinks < Formula
  desc "Text mode browser and Gemini, NNTP, FTP, Gopher, Finger, and BitTorrent client"
  homepage "https://github.com/rkd77/elinks#readme"
  url "https://ghproxy.com/https://github.com/rkd77/elinks/releases/download/v0.16.1/elinks-0.16.1.tar.xz"
  sha256 "825f65819d39c4890f81b5bb6f3a4197542e58908d40a5c52ff8d5ecf5bf8fae"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b2e1dd238b70becd3976f3a79f2397e9c9fc8f7e9c4ceede41c7e0cd76640d53"
    sha256 cellar: :any,                 arm64_monterey: "30aa20c58c1745c000b45d14a6405292398fbd216684eb99bb173c4fd7fa6368"
    sha256 cellar: :any,                 arm64_big_sur:  "9762cc8cd5b6bc4b2a4f186c8ce37cfa6e70f909d7ff33e820815597965c5e8c"
    sha256 cellar: :any,                 ventura:        "83e88e06d52a3b1a38fbceaf80c48d9d0e81ab386966368141f2ef31461aefdc"
    sha256 cellar: :any,                 monterey:       "1f3457b85aa91f3d07708b3f15a3824392dd1556a0153b332abd691c47e3c288"
    sha256 cellar: :any,                 big_sur:        "dccc132f4c45426fb9913d6c6103cc0ff56321ca4593d33cdc5620148efb956f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b970e83b510aa123da7200fbb9d5860fc02513fdf5c9d33b03fe3cea6b9fda1"
  end

  head do
    url "https://github.com/rkd77/elinks.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "libidn2"
  depends_on "openssl@3"
  depends_on "tre"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  conflicts_with "elinks", because: "both install the same binaries"

  def install
    # https://github.com/rkd77/elinks/issues/47#issuecomment-1190547847 parallelization issue.
    ENV.deparallelize
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-nls",
                          "--enable-256-colors",
                          "--enable-88-colors",
                          "--enable-bittorrent",
                          "--enable-cgi",
                          "--enable-exmode",
                          "--enable-finger",
                          "--enable-gemini",
                          "--enable-gopher",
                          "--enable-html-highlight",
                          "--enable-nntp",
                          "--enable-true-color",
                          "--with-brotli",
                          "--with-openssl",
                          "--with-tre",
                          "--without-gnutls",
                          "--without-perl",
                          "--without-spidermonkey",
                          "--without-x",
                          "--without-xterm"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.html").write <<~EOS
      <!DOCTYPE html>
      <title>Hello World!</title>
      Abracadabra
    EOS
    assert_match "Abracadabra",
      shell_output("#{bin}/elinks -dump test.html").chomp
  end
end