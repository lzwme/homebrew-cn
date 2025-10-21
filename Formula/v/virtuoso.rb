class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com"
  url "https://ghfast.top/https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.16/virtuoso-opensource-7.2.16.tar.gz"
  sha256 "0a70dc17f0e333d73307c9c46e8a7a82df70a410ddfe027a5bf7ba6c9204a928"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e12002e4f941f27a576e940b39a2d70cb6ad040f65b3c2a8c012def31f9ab16"
    sha256 cellar: :any,                 arm64_sequoia: "2f1513bc01588c8a278253aad7557f0b14cd297e051b1ae39576e16fc779b6f7"
    sha256 cellar: :any,                 arm64_sonoma:  "d00998fbe031ce5df6cde22125bc017f20ef2763af9b2cc433d9eae3a95433c6"
    sha256 cellar: :any,                 sonoma:        "03ba42739b024430e37704edac175f60dcae3f08af2e38876cefdc09c82d99b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab5e8186e1d41064571c5a3471d87b261e7e5cd3eebd6994d848624b74703319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea3b5e195f0f6ba1e23280505bc3dcd973a07676a939967c0f5c0744212f6865"
  end

  head do
    url "https://github.com/openlink/virtuoso-opensource.git", branch: "develop/7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "net-tools" => :build
    depends_on "xz" # for liblzma
  end

  conflicts_with "unixodbc", because: "both install `isql` binaries"

  skip_clean :la

  # Support openssl 3.6, upstream pr ref, https://github.com/openlink/virtuoso-opensource/pull/1364
  patch :DATA

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--without-internal-zlib"
    system "make", "install"
  end

  def caveats
    <<~EOS
      NOTE: the Virtuoso server will start up several times on port 1111
      during the install process.
    EOS
  end

  test do
    system bin/"virtuoso-t", "+checkpoint-only"
  end
end

__END__
diff --git a/configure b/configure
index 2953300..a4c8766 100755
--- a/configure
+++ b/configure
@@ -23182,8 +23182,8 @@ main (void)
 	/* LibreSSL defines OPENSSL_VERSION_NUMBER 0x20000000L but uses a compatible API to OpenSSL v1.0.x */
 	#elif OPENSSL_VERSION_NUMBER < 0x1020000fL
 	/* OpenSSL versions 0.9.8e - 1.1.1 are supported */
-       #elif OPENSSL_VERSION_NUMBER < 0x30600000L
-       /* OpenSSL versions 3.0.x - 3.5.x are supported */
+       #elif OPENSSL_VERSION_NUMBER < 0x30700000L
+       /* OpenSSL versions 3.0.x - 3.6.x are supported */
 	#else
 	#error OpenSSL version too new
 	#endif