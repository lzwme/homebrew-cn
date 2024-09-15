class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https:netdata.cloud"
  url "https:github.comnetdatanetdatareleasesdownloadv1.44.3netdata-v1.44.3.tar.gz"
  sha256 "50df30a9aaf60d550eb8e607230d982827e04194f7df3eba0e83ff7919270ad2"
  license "GPL-3.0-or-later"
  revision 9

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "4cbb3ade217a18435df9cfc62358c6789c3fbac8dc57793d8f1bbfcdba67beeb"
    sha256 arm64_sonoma:  "0e64a6702d4b810c239a8d29eccbb563581afb47bd71b4aa3b9484c114f92c45"
    sha256 arm64_ventura: "752fdfa4ce439522278c01802d7bfed14884c4875424d48129e5272fc63491d2"
    sha256 sonoma:        "f367597be28040a18f4fce8bdd6e9b92ad8235d5cb2e17d495c54884161e8fdd"
    sha256 ventura:       "73ed020aca0817d603dd3dabadd25a418138f6a8f49474fef16f3fc1e5f54242"
    sha256 x86_64_linux:  "2ceb0e100439aa0509ad6d82e20b0924716e8c0c548af50f58072146cea15ea4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "m4" => :build
  depends_on "pkg-config" => :build
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
      system ".configure", "--disable-debug", "--disable-dependency-tracking",
          "--disable-shared", "--prefix=#{judyprefix}"

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
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
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
    system ".configure", *args
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
    system "#{sbin}netdata", "-W", "set", "registry", "netdata unique id file",
                              "#{testpath}netdata.unittest.unique.id",
                              "-W", "set", "registry", "netdata management api key file",
                              "#{testpath}netdata.api.key"
  end
end