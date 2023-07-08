class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://netdata.cloud/"
  url "https://ghproxy.com/https://github.com/netdata/netdata/releases/download/v1.40.1/netdata-v1.40.1.tar.gz"
  sha256 "cc86172acd5e6ec05bc0fa86a50d967502a264d8adf7f79293923ccd8febb251"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "0b44428889581ff7165334228da42785fb25763d8c8eb6b6b7f0161f7df78cd0"
    sha256 arm64_monterey: "c8159a9fc98bdb85b5f6201c5cb7a78821bc1d74ae77e8a2ce69ba6e8a93d59b"
    sha256 arm64_big_sur:  "b5f6bd4070370f0dde62b619e70e442e5efbd4710dba6f7dabed4a14fd9d021e"
    sha256 ventura:        "5bb6bd953e01232562e65b51837286287fdc971a673c6624fe59d63926fb9f5b"
    sha256 monterey:       "9048cfa0172fa0163e167587287116d304a55717bd720531276b982574929b13"
    sha256 big_sur:        "9c32907c656326ee5259c8679735bc4888b4ea565309169458316963b8c03ca0"
    sha256 x86_64_linux:   "04ea80142e1d2c4e46a181ce6eff65ca2bce91eff9ec21906bc7a52ea60801bc"
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

  # Support Protobuf 22+.
  # https://github.com/netdata/netdata/pull/15266
  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/5e3398d5a5a67447d86867581ee4a7df3dee98cb/netdata/protobuf-22.patch"
    sha256 "b8b60037786d77aff0ef1c15bada5c929de01b370f9bae1e52c6f5f707780eb6"
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