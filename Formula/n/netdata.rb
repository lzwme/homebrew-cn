class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https:netdata.cloud"
  url "https:github.comnetdatanetdatareleasesdownloadv1.44.2netdata-v1.44.2.tar.gz"
  sha256 "9b9267b03af90fe8754f2fb5d16f7f6c60f770d2e890dbc55fd9dcdfd2a4179a"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "25051c44fe12834ff38558de6ddc7d28f3a8473b2e8beeecfd43cde95b314cd0"
    sha256 arm64_ventura:  "e00befb787613300c2b1f4e6f2e5443f01a753e3266c9d207f8e1ff971d54f64"
    sha256 arm64_monterey: "cca6126280b0f68f8ec68e380832cd6c143bc8a2c612b44469e1aee2fa948522"
    sha256 sonoma:         "5a14653fb1b7e5ab40be0f2ce91796cba4525c167a54578286b5401571d00600"
    sha256 ventura:        "8a3b1eb8b111c8e78f8fbac9f403897406ead6afd6de20a8a45027d4b1075b58"
    sha256 monterey:       "744c3331b0b569b0df5f68b0055744463c235ff0772ed842c82065269478995e"
    sha256 x86_64_linux:   "cc2f043657606e6399e43851e79cb46c75123794cefb26d2aaa07183e4b64ea2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "m4" => :build
  depends_on "pkg-config" => :build
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