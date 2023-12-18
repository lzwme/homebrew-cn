class Nghttp2 < Formula
  desc "HTTP2 C Library"
  homepage "https:nghttp2.org"
  url "https:github.comnghttp2nghttp2releasesdownloadv1.58.0nghttp2-1.58.0.tar.gz"
  mirror "http:fresh-center.netlinuxwwwnghttp2-1.58.0.tar.gz"
  sha256 "9ebdfbfbca164ef72bdf5fd2a94a4e6dfb54ec39d2ef249aeb750a91ae361dfb"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "fc91ff1ffd9523dd179b991196320a56720a960a3e9f961b3ac7fb6ad0629e74"
    sha256 arm64_ventura:  "7ca6645ee5f48a81cea4cf69f5a8d2577c62344170f823a3c2d46ddfc934e614"
    sha256 arm64_monterey: "836fdc17da9ec7291ae4368b7c129cafd059e6a1b27cc68bcffe1e66777748ae"
    sha256 sonoma:         "845d06539ca8d42a13959e7e764f2878084b701d31029e658c4a1743e009587d"
    sha256 ventura:        "c297bce3d6d06a181b8921264f141b9c26786eadf5070297fdb1455dba56c911"
    sha256 monterey:       "9e4f556bc150c96076fb610af7a8dfc7f66cc0790368b8a2e641450a60493cdf"
    sha256 x86_64_linux:   "d95693fa598e1271c053a8eed14c20f8ea14bf511cfd6891bdb25aff88c4c657"
  end

  head do
    url "https:github.comnghttp2nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "c-ares"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "libnghttp2"
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  # Fix: shrpx_api_downstream_connection.cc:57:3: error:
  # array must be initialized with a brace-enclosed initializer
  # https:github.comnghttp2nghttp2pull1269
  patch do
    on_linux do
      url "https:github.comnghttp2nghttp2commit829258e7038fe7eff849677f1ccaeca3e704eb67.patch?full_index=1"
      sha256 "c4bcf5cf73d5305fc479206676027533bb06d4ff2840eb672f6265ba3239031e"
    end
  end

  def install
    # fix for clang not following C++14 behaviour
    # https:github.commacportsmacports-portscommit54d83cca9fc0f2ed6d3f873282b6dd3198635891
    inreplace "srcshrpx_client_handler.cc", "return dconn;", "return std::move(dconn);"

    # Don't build nghttp2 library - use the previously built one.
    inreplace "Makefile.in", (SUBDIRS =) lib, "\\1"
    inreplace Dir["**Makefile.in"] do |s|
      # These don't exist in all files, hence audit_result being false.
      s.gsub!(%r{^(LDADD = )\$[({]top_builddir[)}]liblibnghttp2\.la}, "\\1-lnghttp2", false)
      s.gsub!(%r{\$[({]top_builddir[)}]liblibnghttp2\.la}, "", false)
    end

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --disable-examples
      --disable-hpack-tools
      --disable-python-bindings
      --without-systemd
    ]

    system "autoreconf", "-ivf" if build.head?
    system ".configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin"nghttp", "-nv", "https:nghttp2.org"
    refute_path_exists lib
  end
end