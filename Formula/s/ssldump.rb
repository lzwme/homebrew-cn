class Ssldump < Formula
  desc "SSLv3/TLS network protocol analyzer"
  homepage "https://ssldump.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ssldump/ssldump/0.9b3/ssldump-0.9b3.tar.gz"
  sha256 "6422c16718d27c270bbcfcc1272c4f9bd3c0799c351f1d6dd54fdc162afdab1e"
  revision 2

  # This regex intentionally matches unstable versions, as only a beta version
  # (0.9b3) is available at the time of writing.
  livecheck do
    url :stable
    regex(%r{url=.*?/ssldump/([^/]+)/[^/]+\.t}i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "8fc8ca0f4b1fde91e0b45420c7a49400de0a6b350a2745c493914b19558dd734"
    sha256 cellar: :any,                 arm64_ventura:  "83eb5a5e9b13ec2a5dbd1d0476b58e803318ac8243939997c91c61b08af6a705"
    sha256 cellar: :any,                 arm64_monterey: "db2444ab2212b47e715351f51179244c4c141890f4b04af950fdb715668a3acc"
    sha256 cellar: :any,                 sonoma:         "15554437c179041d78da4e2e64b9cf777f8b8f630d76e334f9ac3dac7d313a94"
    sha256 cellar: :any,                 ventura:        "bae2a0625a830a84b52bc1067f0cbc2a97cb7bc699ee1a47a59edfec4f54248a"
    sha256 cellar: :any,                 monterey:       "52da057720aa30c60b9a3ac7be09f9e5337ee3b1123108d44c5901e425a19bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6e48e727151bd543bb0784fbd8a79eb90acbba5c6cf369538ea8316e8ad9773"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libpcap"
  depends_on "openssl@3"

  # reorder include files
  # https://sourceforge.net/p/ssldump/bugs/40/
  # increase pcap sample size from an arbitrary 5000 the max TLS packet size 18432
  patch :DATA

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["LIBS"] = "-lssl -lcrypto"

    # .dylib, not .a
    inreplace "configure.in", "if test -f $dir/libpcap.a; then",
                              "if test -f $dir/#{shared_library("libpcap")}; then"

    # The configure file that ships in the 0.9b3 tarball is too old to work
    # with Xcode 12
    system "autoreconf", "--verbose", "--install", "--force"

    # Normally we'd get these files installed as part of autoreconf.  However,
    # this project doesn't use Makefile.am so they're not brought in.  The copies
    # in the 0.9b3 tarball are too old to detect MacOS
    %w[config.guess config.sub].each do |fn|
      cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
    end

    system "./configure", *std_configure_args,
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--mandir=#{man}",
                          "--with-pcap=#{Formula["libpcap"].opt_prefix}"
    system "make"
    # force install as make got confused by install target and INSTALL file.
    system "make", "install", "-B"
  end

  test do
    system "#{sbin}/ssldump", "-v"
  end
end

__END__
--- a/base/pcap-snoop.c	2010-03-18 22:59:13.000000000 -0700
+++ b/base/pcap-snoop.c	2010-03-18 22:59:30.000000000 -0700
@@ -46,10 +46,9 @@

 static char *RCSSTRING="$Id: pcap-snoop.c,v 1.14 2002/09/09 21:02:58 ekr Exp $";

-
 #include <pcap.h>
 #include <unistd.h>
-#include <net/bpf.h>
+#include <pcap-bpf.h>
 #ifndef _WIN32
 #include <sys/param.h>
 #endif
--- a/base/pcap-snoop.c	2012-04-06 10:35:06.000000000 -0700
+++ b/base/pcap-snoop.c	2012-04-06 10:45:31.000000000 -0700
@@ -286,7 +286,7 @@
           err_exit("Aborting",-1);
         }
       }
-      if(!(p=pcap_open_live(interface_name,5000,!no_promiscuous,1000,errbuf))){
+      if(!(p=pcap_open_live(interface_name,18432,!no_promiscuous,1000,errbuf))){
 	fprintf(stderr,"PCAP: %s\n",errbuf);
 	err_exit("Aborting",-1);
       }