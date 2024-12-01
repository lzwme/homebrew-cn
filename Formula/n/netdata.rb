class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https:netdata.cloud"
  url "https:github.comnetdatanetdatareleasesdownloadv1.44.3netdata-v1.44.3.tar.gz"
  sha256 "50df30a9aaf60d550eb8e607230d982827e04194f7df3eba0e83ff7919270ad2"
  license "GPL-3.0-or-later"
  revision 12

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "0c55ee1cc93da456179885ada80b4daaad2c5958b67aa3aabaf1b3864afb39ef"
    sha256 arm64_sonoma:  "e832dfd7261ec4bc4f9fec9105ccd4b70fd7e9ed8a714897638c0be8b09c94d2"
    sha256 arm64_ventura: "d7ce2b70a60f06fc1d4080c29827a033580e2e629abb79fd1887be34a3524e7c"
    sha256 sonoma:        "c2dafecd8588597ff0574caa2be966c612ccf8880252d32d69dba1ce6cafb3d4"
    sha256 ventura:       "e6a968effd243c42ff757b6f0f957cae923e14d9f557b5a01592660aa28bfdba"
    sha256 x86_64_linux:  "2ab4a8881912738a6215f5a3223a186aa01503e5c57813105f964d75bb496e71"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "m4" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "json-c"
  depends_on "libuv"
  depends_on "libyaml"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "protobuf"
  depends_on "protobuf-c"

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  resource "judy" do
    url "https:downloads.sourceforge.netprojectjudyjudyJudy-1.0.5Judy-1.0.5.tar.gz"
    sha256 "d2704089f85fdb6f2cd7e77be21170ced4b4375c03ef1ad4cf1075bd414a63eb"
  end

  def install
    # daemonbuildinfo.c saves the configure args and certain environment
    # variables used to build netdata. Remove the environment variable that may
    # reference `HOMEBREW_LIBRARY`, which can make bottling fail.
    ENV.delete "PKG_CONFIG_LIBDIR"

    # https:github.comprotocolbuffersprotobufissues9947
    ENV.append_to_cflags "-DNDEBUG"

    # We build judy as static library, so we don't need to install it
    # into the real prefix
    judyprefix = "#{buildpath}resourcesjudy"

    resource("judy").stage do
      system ".configure", "--disable-shared", *std_configure_args(prefix: judyprefix)

      # Parallel build is broken
      ENV.deparallelize do
        system "make", "install"
      end
    end

    ENV["PREFIX"] = prefix
    ENV.append "CFLAGS", "-I#{judyprefix}include"
    ENV.append "LDFLAGS", "-L#{judyprefix}lib"

    # We need C++17 for protobuf.
    inreplace "configure.ac", "# AX_CXX_COMPILE_STDCXX(17, noext, optional)",
                              "AX_CXX_COMPILE_STDCXX(17, noext, mandatory)"

    system "autoreconf", "--force", "--install", "--verbose"
    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --libexecdir=#{libexec}
      --with-math
      --with-zlib
      --enable-dbengine
      --with-user=netdata
    ]
    if OS.mac?
      args << "UUID_LIBS=-lc"
      args << "UUID_CFLAGS=-Iusrinclude"
    else
      args << "UUID_LIBS=-luuid"
      args << "UUID_CFLAGS=-I#{Formula["util-linux"].opt_include}"
    end
    system ".configure", *args, *std_configure_args
    system "make", "clean"
    system "make", "install"

    (etc"netdata").install "systemnetdata.conf"
  end

  def post_install
    (var"cachenetdataunittest-dbenginedbengine").mkpath
    (var"libnetdataregistry").mkpath
    (var"libnetdatalock").mkpath
    (var"lognetdata").mkpath
    (var"netdata").mkpath
  end

  service do
    run [opt_sbin"netdata", "-D"]
    working_dir var
  end

  test do
    system sbin"netdata", "-W", "set", "registry", "netdata unique id file",
                           "#{testpath}netdata.unittest.unique.id",
                           "-W", "set", "registry", "netdata management api key file",
                           "#{testpath}netdata.api.key"
  end
end