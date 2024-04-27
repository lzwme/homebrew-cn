class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https:git.madhouse-project.orgalgernonriemann-c-client"
  url "https:git.madhouse-project.orgalgernonriemann-c-clientarchiveriemann-c-client-2.2.1.tar.gz"
  sha256 "65daf32ad043ccd553a8314d1506914c2b71867d24b0e18380cb174e04861303"
  license "EUPL-1.2"
  head "https:git.madhouse-project.orgalgernonriemann-c-client.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7854bc14bd566d2dde42dc063099cfc65f32e76b19753d707c6b2d3b9c25c7cd"
    sha256 cellar: :any,                 arm64_ventura:  "6c8e5b2f98803a91ff957f0052c2f2ba4bbc276fb4116bb244c8179b0f3ac835"
    sha256 cellar: :any,                 arm64_monterey: "10c6ded8a26a5b556881b2dc045175c0c02fd5221c8fb79c58805f30c01c150d"
    sha256 cellar: :any,                 sonoma:         "7392770dda4b7a8a85ad01c6fff29755ebba6bf454569a452e0b179031a2ed20"
    sha256 cellar: :any,                 ventura:        "3cc09e98b21351ff7e33c35664467ffc1c2f7ddec512a3f4fed9aaa2b44b3717"
    sha256 cellar: :any,                 monterey:       "76fd317852de35fce96522105df18ef93ce9d58105f764c7d25715ebd14fadc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aedd6872a9056fc17d3defe1f0602b61653c0b6ebf698df90da0297be259dd4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "json-c"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  # upstream build patch
  patch :DATA

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", "--prefix=#{prefix}", "--with-tls=openssl"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}riemann-client", "send", "-h"
  end
end

__END__
diff --git aMakefile.am bMakefile.am
index caf43c5..9eb8f55 100644
--- aMakefile.am
+++ bMakefile.am
@@ -68,7 +68,7 @@ CLEANFILES			= ${proto_files}

 ${proto_files}: ${top_srcdir}libriemannprotoriemann.proto
 	${AM_V_at} ${mkinstalldirs} ${top_builddir}libriemannproto
-	${AM_V_GEN} protoc-c $^ -I${top_srcdir}libriemannproto --c_out=${top_builddir}libriemannproto
+	${AM_V_GEN} ${PROTOC} $^ -I${top_srcdir}libriemannproto --c_out=${top_builddir}libriemannproto

 if HAVE_VERSIONING
 lib_libriemann_client_@TLS@_la_LDFLAGS += \
diff --git aREADME.md bREADME.md
index f5dcc20..f525e27 100644
--- aREADME.md
+++ bREADME.md
@@ -128,3 +128,7 @@ If, for some reason the build fails, one may need to regenerate the
 `protobuf-c-compiler` generated headers (changes in the compiler are
 known to cause issues). To do this, do a `make distclean` first, and
 then start over from `configure`.
+
+If the protobuf-c compiler fails, and complains about `PROTO3` as maximum
+edition, install protobuf 26+ too, and either start over from `configure`, or
+set the `PROTOC` environment variable to `protoc`.
diff --git aconfigure.ac bconfigure.ac
index 8c4733c..4b48987 100644
--- aconfigure.ac
+++ bconfigure.ac
@@ -35,8 +35,8 @@ AC_PROG_CXX

 LT_INIT([shared])

-AC_CHECK_PROG([HAS_PROTOC_C], [protoc-c], [yes])
-if test x$HAS_PROTOC_C != x"yes"; then
+AC_CHECK_PROGS([PROTOC], [protoc protoc-c])
+if test -z "${PROTOC}"; then
    AC_MSG_ERROR([You need protoc-c installed and on your path to proceed. You can find it at https:github.comprotobuf-cprotobuf-c])
 fi

--
2.44.0