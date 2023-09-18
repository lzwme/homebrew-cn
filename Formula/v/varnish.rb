class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-7.4.0.tgz"
  mirror "https://fossies.org/linux/www/varnish-7.4.0.tgz"
  sha256 "8390153ea23c0f74cb95c0a38682a03446d3bcb770f335227117f81431d5a005"
  license "BSD-2-Clause"

  livecheck do
    url "https://varnish-cache.org/releases/"
    regex(/href=.*?varnish[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "f1dbb7700242eba244ed6a778949697a02f7b6f0c9494ec8e5137a9c5acee1d1"
    sha256 arm64_monterey: "62539feb917cc48c4481f07e3df86ca1eddec247876546089f1731e6333533fd"
    sha256 arm64_big_sur:  "cc36a4c3632e07494bec5075d1c6ad2ca8c5e479652ee7af60f1c4312396fe65"
    sha256 ventura:        "57f4c792449fe195ee486da73928e58d82e7323eff23a3ec935e6c4c71db2ae0"
    sha256 monterey:       "d1b75958942fd0e548d4a80a0ea0887d3f6e231e58f7b967b3160e6a04e4bf5d"
    sha256 big_sur:        "8ef1c7b30f50595ae8a8ca0d5dfa91727f9e0dc149ef8c6fa66f3e060bc8d4fb"
    sha256 x86_64_linux:   "663d787beee8e5355a25b42bf27baf1e124c6ae19b59c86cf70cd904dae9aaa9"
  end

  depends_on "docutils" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre2"

  uses_from_macos "libedit"
  uses_from_macos "ncurses"

  def install
    ENV["PYTHON"] = Formula["python@3.11"].opt_bin/"python3.11"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"

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
         "127.0.0.1:2000", "-a", "0.0.0.0:8080", "-F"]
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
      testpath/"u00008.vtc",
    ]
    tests = testpath.glob("[bmu]*.vtc") - timeout_tests
    # -j: run the tests (using up to half the cores available)
    # -q: only report test failures
    # varnishtest will exit early if a test fails (use -k to continue and find all failures)
    system bin/"varnishtest", "-j", [Hardware::CPU.cores / 2, 1].max, "-q", *tests
  end
end