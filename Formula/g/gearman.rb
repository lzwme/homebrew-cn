class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "https://gearman.org/"
  url "https://ghfast.top/https://github.com/gearman/gearmand/releases/download/1.1.21/gearmand-1.1.21.tar.gz"
  sha256 "2688b83e48f26fdcd4fbaef2413ff1a76c9ecb067d1621d0e0986196efecd308"
  license "BSD-3-Clause"
  revision 6

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "405acbf2c81f96a80a052018dcf795c7bacc5374c410550a14aa914fa7289150"
    sha256 cellar: :any,                 arm64_sonoma:  "e28eb01d2b29084d6f49defdc6f9a3e4c2ace251ff56f46ed66eb79872c1bdd8"
    sha256 cellar: :any,                 arm64_ventura: "1812ff0ae7da5aeb7a43c80ad723ebd7abbbfea6d0c3d506d0fbb57bef4db598"
    sha256 cellar: :any,                 sonoma:        "508907ce358ba952fdd4a23be727265b73a3472902b192518959e67591cc5e93"
    sha256 cellar: :any,                 ventura:       "ace21395e2a741fba1b61329c605ebd3b4fe16006622629786ba631007ae9e60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47eea2606ae931432c0debab148d5f4e1b4cc8cc6a74176c0963e31611cd0751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2617f5bfe8fe5779a942efe2ea1b7fb6fe30cd4abe99868dd4c647c2d16a91a"
  end

  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libmemcached"

  uses_from_macos "gperf" => :build
  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    if OS.mac? && MacOS.version == :high_sierra
      ENV.delete("HOMEBREW_SDKROOT")
      ENV.delete("SDKROOT")
    end

    # https://bugs.launchpad.net/gearmand/+bug/1368926
    Dir["tests/**/*.cc", "libtest/main.cc"].each do |test_file|
      next unless File.read(test_file).include?("std::unique_ptr")

      inreplace test_file, "std::unique_ptr", "std::auto_ptr"
    end

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-cyassl
      --disable-hiredis
      --disable-libdrizzle
      --disable-libpq
      --disable-libtokyocabinet
      --disable-ssl
      --enable-libmemcached
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-memcached=#{Formula["memcached"].opt_bin}/memcached
      --with-sqlite3
      --without-mysql
      --without-postgresql
    ]

    ENV.append_to_cflags "-DHAVE_HTONLL"
    ENV.append "CXXFLAGS", "-std=c++14"

    (var/"log").mkpath
    system "./configure", *args
    system "make", "install"
  end

  service do
    run opt_sbin/"gearmand"
  end

  test do
    assert_match(/gearman\s*Error in usage/, shell_output("#{bin}/gearman --version 2>&1", 1))
  end
end