class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-7.7.2.tgz"
  mirror "https://fossies.org/linux/www/varnish-7.7.2.tgz"
  sha256 "fda7750e1281a20e9cccc6c666481d2437fa7c0d816592c86e4fb7ba7fc464ad"
  license "BSD-2-Clause"

  livecheck do
    url "https://varnish-cache.org/releases/"
    regex(/href=.*?varnish[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_sequoia: "e41fed283f2c9b4394117e42f2e9fa8fb823ac7b97a9ed3fb0baa014b09dd669"
    sha256               arm64_sonoma:  "f4d2dc9453262900127df7752908a13643d790a3f3b4318f9ae2a02a97e32daf"
    sha256               arm64_ventura: "f7ce89466660a8932112810bd13b2cf5b7696f10e5f1168a4c955ef8e429c116"
    sha256 cellar: :any, sonoma:        "152febc5f83c03cababb88d8e7c51db5bcf8c4150662402ff4589e3d874282cd"
    sha256 cellar: :any, ventura:       "09249cfa3e8fa885429097c6f0b9a0d8c1a3a9cc7451dd140e07453659c0e79a"
    sha256               arm64_linux:   "8dcfbfeade0dc3390184b3def3a6a4553ce9c03c74dbbd542883ec0113dc6a8d"
    sha256               x86_64_linux:  "58fb2ac40d4757484a81d33fc480795816751776cb86b3cceafbb3a8d1dbdadc"
  end

  depends_on "docutils" => :build
  depends_on "graphviz" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre2"

  uses_from_macos "python" => :build
  uses_from_macos "libedit"
  uses_from_macos "ncurses"

  # macos compatibility patches, upstream pr ref, https://github.com/varnishcache/varnish-cache/pull/4339
  patch do
    url "https://github.com/varnishcache/varnish-cache/commit/3e679cd0aa093f7b1c426857d24a88d3db747f24.patch?full_index=1"
    sha256 "677881ed5cd0eda2e1aa799ca54601b44a96675763233966c4d101b83ccdfd73"
  end
  patch do
    url "https://github.com/varnishcache/varnish-cache/commit/acbb1056896f6cf4115cc2a6947c9dbd8003176e.patch?full_index=1"
    sha256 "915c5b560aa473ed139016b40c9e6c8a0a4cce138dd1126a63e75b58d8345e73"
  end

  def install
    system "./configure", "--localstatedir=#{var}", *std_configure_args

    # flags to set the paths used by varnishd to load VMODs and VCL,
    # pointing to the ${HOMEBREW_PREFIX}/ shared structure so other packages
    # can install VMODs and VCL.
    ENV.append_to_cflags "-DVARNISH_VMOD_DIR='\"#{HOMEBREW_PREFIX}/lib/varnish/vmods\"'"
    ENV.append_to_cflags "-DVARNISH_VCL_DIR='\"#{pkgetc}:#{HOMEBREW_PREFIX}/share/varnish/vcl\"'"

    # Fix missing pthread symbols on Linux
    ENV.append_to_cflags "-pthread" if OS.linux?

    system "make", "install", "CFLAGS=#{ENV.cflags}"

    (etc/"varnish").install "etc/example.vcl" => "default.vcl"
    (var/"varnish").mkpath

    (pkgshare/"tests").install buildpath.glob("bin/varnishtest/tests/*.vtc")
    (pkgshare/"tests/vmod").install buildpath.glob("vmod/tests/*.vtc")
  end

  service do
    run [opt_sbin/"varnishd", "-n", var/"varnish", "-f", etc/"varnish/default.vcl", "-s", "malloc,1G", "-T",
         "127.0.0.1:2000", "-a", "127.0.0.1:8080", "-F"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"varnish/varnish.log"
    error_log_path var/"varnish/varnish.log"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/varnishd -V 2>&1")

    # run a subset of the varnishtest tests:
    # - b*.vtc (basic functionality)
    # - m*.vtc (VMOD modules, including loading), but skipping m00000.vtc which is known to fail
    #   but is "nothing of concern" (see varnishcache/varnish-cache#3710)
    # - u*.vtc (utilities and background processes)
    testpath = pkgshare/"tests"
    timeout_tests = [
      testpath/"m00000.vtc",
      testpath/"b00047.vtc",
      testpath/"b00084.vtc",
      testpath/"b00086.vtc",
      testpath/"u00008.vtc",
    ]
    tests = testpath.glob("[bmu]*.vtc") - timeout_tests
    # -j: run the tests (using up to half the cores available)
    # -q: only report test failures
    # varnishtest will exit early if a test fails (use -k to continue and find all failures)
    system bin/"varnishtest", "-j", [Hardware::CPU.cores / 2, 1].max, "-q", *tests
  end
end