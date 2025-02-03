class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https:memcached.org"
  url "https:www.memcached.orgfilesmemcached-1.6.35.tar.gz"
  sha256 "eb4529317eec818efc44352ddd1f959fd20882bed1ae292a5788bd7a4966f7c1"
  license "BSD-3-Clause"
  head "https:github.commemcachedmemcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\.i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9ba7706a30dca78c30c6c6ea4461e3c882a626c6a33c61a803fe592d490b8654"
    sha256 cellar: :any,                 arm64_sonoma:  "75b2b4aa39f7d2fef8af0a6a974a93b7d8e287624b0a4cfb49cc8da82e31d294"
    sha256 cellar: :any,                 arm64_ventura: "ff76c121d0378612ecf21f30e0ee5b3430850e4f9ca0b33cd1d89a7b05372abb"
    sha256 cellar: :any,                 sonoma:        "e60f428b171705cb108ceb05e45a948df8728bad1fc9ee528d69d98ec7f9db28"
    sha256 cellar: :any,                 ventura:       "0225a1ba440e46ba5a12212c6de4fc718fe390b994eae652e542e502ce3302e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2111048260b19054e9f31f82d82d28820b1f2e4074a60fc1f28d9471002985a8"
  end

  depends_on "libevent"
  depends_on "openssl@3"

  def install
    system ".configure", "--prefix=#{prefix}", "--disable-coverage", "--enable-tls"
    system "make", "install"
  end

  service do
    run [opt_bin"memcached", "-l", "localhost"]
    working_dir HOMEBREW_PREFIX
    keep_alive true
    run_type :immediate
  end

  test do
    pidfile = testpath"memcached.pid"
    port = free_port
    args = %W[
      --listen=127.0.0.1
      --port=#{port}
      --daemon
      --pidfile=#{pidfile}
    ]
    args << "--user=#{ENV["USER"]}" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    system bin"memcached", *args
    sleep 1
    assert_predicate pidfile, :exist?, "Failed to start memcached daemon"
    pid = (testpath"memcached.pid").read.chomp.to_i
    Process.kill "TERM", pid
  end
end