class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.43.tar.gz"
  sha256 "8042ee26e004efa0db41ca4a7c713f759c3280c2f8bee438579f13de1e509435"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "13cf50e90e52008746e97f5c65755f61ac39128b419f3619eef40c8c5ef66be6"
    sha256 cellar: :any, arm64_sequoia: "9e5128aac09b4ede71d25950be42d285f6cab708428548e2e27b469c56df9113"
    sha256 cellar: :any, arm64_sonoma:  "67da7b0f64e58fd60f83bf018be877a5a4579ab5911fb6921347bb730551c5f6"
    sha256 cellar: :any, sonoma:        "1615a6ced981336de98fe4e24d4176aba498799a86c51484e2e6b61576e13b62"
    sha256 cellar: :any, arm64_linux:   "5ef59042f921ebb0803e19a1427dfffbe8f99ace1e9505ae811985413e0481aa"
    sha256 cellar: :any, x86_64_linux:  "e4a949bc47becf91bec7a9cf68e07b421d4707871fd51d37bdf7040faa16dda2"
  end

  head do
    url "https://github.com/memcached/memcached.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libevent"
  depends_on "openssl@3"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-coverage", "--enable-tls", *std_configure_args
    system "make", "install"
  end

  service do
    run [opt_bin/"memcached", "-l", "localhost"]
    working_dir HOMEBREW_PREFIX
    keep_alive true
    run_type :immediate
  end

  test do
    pidfile = testpath/"memcached.pid"
    port = free_port
    args = %W[
      --listen=127.0.0.1
      --port=#{port}
      --daemon
      --pidfile=#{pidfile}
    ]
    args << "--user=#{ENV["USER"]}" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    system bin/"memcached", *args
    sleep 1
    assert_path_exists pidfile, "Failed to start memcached daemon"
    pid = (testpath/"memcached.pid").read.chomp.to_i
    Process.kill "TERM", pid
  end
end