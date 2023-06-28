class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://netdata.cloud/"
  url "https://ghproxy.com/https://github.com/netdata/netdata/releases/download/v1.40.0/netdata-v1.40.0.tar.gz"
  sha256 "73b43bada63a793bc27c940af7ef28637d76aba1c014bea01eae8cb77c168175"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "7048bbea52ab09eaeb3d5d1f6e20e3ff6250e694a63579d344452496a7895dfe"
    sha256 arm64_monterey: "ae3d2a4fc4d314fe21e7b5d4e4a7130253570b99b3c7ae6d55efd30e453b22ad"
    sha256 arm64_big_sur:  "a2ccf8b988ef62bab02617fd9cfbb0ca231d1c6dab39d18e87357133f05d7952"
    sha256 ventura:        "3b41c31f4468220e1ef97c9554935e6a1230162feea25cf4e63de00b9061b56c"
    sha256 monterey:       "d24f607374bdee1b3d80210408be7df2037ddb7ee25d2e1d62990d0535174263"
    sha256 big_sur:        "48af197fe5d62dadf4e182de7f8bd8d5f1a3a91f867e19d5205e7c2067540a70"
    sha256 x86_64_linux:   "86c4bde9d238cbe08fff65196f701f97c9b878a29b887648e12e3df6504929a2"
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

  # Remove when https://github.com/netdata/netdata/pull/15195 is merged and
  # included in a release.
  patch do
    url "https://github.com/netdata/netdata/commit/1189341615b642c27faee459b015059778247a8f.patch?full_index=true"
    sha256 "61befe96c549f1428eeb8773864c36bcb825b21854f36a6433112ea9f80dc91d"
  end

  # Support Protobuf 22+.
  # https://github.com/netdata/netdata/pull/15266
  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/1d37b0b94b7b6b54ac207ad59951b568eb0f9a53/netdata/protobuf-22.patch"
    sha256 "8074aca24cac248378e6410da434703ed7b2fc9cc54fb34b3e495de66332b8b3"
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