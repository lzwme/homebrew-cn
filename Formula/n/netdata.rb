class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://netdata.cloud/"
  url "https://ghproxy.com/https://github.com/netdata/netdata/releases/download/v1.43.2/netdata-v1.43.2.tar.gz"
  sha256 "d4a7ea2717ac7c8f04865f18e13aeaa0a36784156059f1b5ced75a44f74afc4d"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "eed6ceb5c152abd3aea853872ae7538ef95d3a305ded9633a762f007aa1ace2a"
    sha256 arm64_ventura:  "7e0911191da143375a398262f57dc56e1b0e067cb29477e2efe6ae480da87573"
    sha256 arm64_monterey: "5ac4680c5c01deea02dc057f6198dedee3744ccf0a92f2670c4e4edeaa7a8954"
    sha256 sonoma:         "9aac1a250a523651ad35fa04c519600a720e15cb9c047c3afa0eb496fbb6d360"
    sha256 ventura:        "b451f7268960bbe6e97353b1ae42b28342e32277a7bc63eed7e06cd8e4037cef"
    sha256 monterey:       "4d6ac624a178d59306dc90ba1258651e48b5c5592e2a470bc80a5f601124869e"
    sha256 x86_64_linux:   "ae7e5246152b1eeee80529f1a1c354d463043aa0239870928fc219b3ac29a42e"
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
    # daemon/buildinfo.c saves the configure args and certain environment
    # variables used to build netdata. Remove the environment variable that may
    # reference `HOMEBREW_LIBRARY`, which can make bottling fail.
    ENV.delete "PKG_CONFIG_LIBDIR"

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