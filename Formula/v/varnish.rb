class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://ghfast.top/https://github.com/varnish/varnish/releases/download/varnish-9.0.3/varnish-9.0.3.tar.gz"
  sha256 "2aac11dd95329b0cea148d478168b3ccc6fe45fab38160c440159386403b69fd"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "9bc364d2ce1c2fa7d3a2400959fc35c8b0aaf7dc5f209a848e69cd0e5979813b"
    sha256 arm64_sequoia: "bcc038aa04dd5c5cd7a00ece939ee456f62cb955dd97bf3289695e0529291442"
    sha256 arm64_sonoma:  "4f79ce550e36b4d6aa2b868df9bf50192102371bb1baf92d70ea35b481817d7f"
    sha256 sonoma:        "855a5c992fc7fa2f13597597f1d966ed8022c22b8c898da30b1120668c97784f"
    sha256 arm64_linux:   "7c236bb7320009d0b1dfa405dfd14f6a59408409c77dee3a975a8b4af4f38bd8"
    sha256 x86_64_linux:  "a9227348792ecdf765b221fc6a6ccc5668d4e0cf31e81eb6fbda47eb72c1cd40"
  end

  depends_on "docutils" => :build
  depends_on "graphviz" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "python" => :build
  uses_from_macos "libedit"
  uses_from_macos "ncurses"

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

    (pkgshare/"tests").install buildpath.glob("bin/vinyltest/tests/*.vtc")
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

    # test suites need libvmod_debug.so, see discussions in https://github.com/varnishcache/varnish-cache/issues/4393
    debug_tests = [
      testpath/"b00040.vtc",
      testpath/"b00070.vtc",
      testpath/"b00085.vtc",
      testpath/"b00092.vtc",
      testpath/"m00019.vtc",
      testpath/"m00021.vtc",
      testpath/"m00023.vtc",
      testpath/"m00022.vtc",
      testpath/"b00060.vtc",
      testpath/"m00025.vtc",
      testpath/"m00027.vtc",
      testpath/"m00048.vtc",
      testpath/"m00049.vtc",
      testpath/"m00054.vtc",
      testpath/"m00053.vtc",
      testpath/"m00051.vtc",
      testpath/"m00052.vtc",
      testpath/"m00059.vtc",
      testpath/"m00060.vtc",
      testpath/"m00061.vtc",
    ]
    tests = testpath.glob("[bmu]*.vtc") - timeout_tests - debug_tests
    # -j: run the tests (using up to half the cores available)
    # -q: only report test failures
    # varnishtest will exit early if a test fails (use -k to continue and find all failures)
    system bin/"varnishtest", "-j", [Hardware::CPU.cores / 2, 1].max, "-q", *tests
  end
end