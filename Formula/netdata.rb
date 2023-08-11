class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://netdata.cloud/"
  url "https://ghproxy.com/https://github.com/netdata/netdata/releases/download/v1.42.0/netdata-v1.42.0.tar.gz"
  sha256 "10c5685ba184a348fb75d0ce2d011bf9227774a07de60197a81b04373d5ea333"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "9d50638615e89e2dfda3388f386a21040004763a02547ada4b8b62903b44d0b0"
    sha256 arm64_monterey: "f047d2792f98c8817ac797328d4843146e6a9ea2cfc7a8d80c349776235bb137"
    sha256 arm64_big_sur:  "747f9ce8b430cd7f1ea7660f4dd05a2f18708bbead1ef75b74b685d2f75c7d37"
    sha256 ventura:        "1a7b4b9b7b9348e0f58d5b9b18b4778ed6a9feea842c1d5887eadfc01421cb0e"
    sha256 monterey:       "57f3c8a9acf9d94a4fa944bec24c3bcb3469b03c2d607d5e921788cb38563fb8"
    sha256 big_sur:        "d25be43f0d5af5a16191526870d85bbb98d7bed3a8db6784945be481682f2311"
    sha256 x86_64_linux:   "5d348442d8436cfd585c2a0032ca0a0956f57f41ba0ca7392665bdb8d680c0bd"
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
  depends_on "protobuf"
  depends_on "protobuf-c"

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  resource "judy" do
    url "https://downloads.sourceforge.net/project/judy/judy/Judy-1.0.5/Judy-1.0.5.tar.gz"
    sha256 "d2704089f85fdb6f2cd7e77be21170ced4b4375c03ef1ad4cf1075bd414a63eb"
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

    # We build judy as static library, so we don't need to install it
    # into the real prefix
    judyprefix = "#{buildpath}/resources/judy"

    resource("judy").stage do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
          "--disable-shared", "--prefix=#{judyprefix}"

      # Parallel build is broken
      ENV.deparallelize do
        system "make", "install"
      end
    end

    ENV["PREFIX"] = prefix
    ENV.append "CFLAGS", "-I#{judyprefix}/include"
    ENV.append "LDFLAGS", "-L#{judyprefix}/lib"

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
      args << "UUID_CFLAGS=-I/usr/include"
    else
      args << "UUID_LIBS=-luuid"
      args << "UUID_CFLAGS=-I#{Formula["util-linux"].opt_include}"
    end
    system "./configure", *args
    system "make", "clean"
    system "make", "install"

    (etc/"netdata").install "system/netdata.conf"
  end

  def post_install
    (var/"cache/netdata/unittest-dbengine/dbengine").mkpath
    (var/"lib/netdata/registry").mkpath
    (var/"lib/netdata/lock").mkpath
    (var/"log/netdata").mkpath
    (var/"netdata").mkpath
  end

  service do
    run [opt_sbin/"netdata", "-D"]
    working_dir var
  end

  test do
    system "#{sbin}/netdata", "-W", "set", "registry", "netdata unique id file",
                              "#{testpath}/netdata.unittest.unique.id",
                              "-W", "set", "registry", "netdata management api key file",
                              "#{testpath}/netdata.api.key"
  end
end