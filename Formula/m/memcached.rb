class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https:memcached.org"
  url "https:www.memcached.orgfilesmemcached-1.6.37.tar.gz"
  sha256 "74a0629370f6bf60873937e439cd59659fbd7a84f24c1095bc082da0c8406969"
  license "BSD-3-Clause"
  head "https:github.commemcachedmemcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\.i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aae8d6d796a681022254dacda81208e9c2bc1e81914575ebdcd1c7d0aed601c7"
    sha256 cellar: :any,                 arm64_sonoma:  "308adc27f178a43c80d187ed6b510415cba6621a91efa84bbc29725f5f714412"
    sha256 cellar: :any,                 arm64_ventura: "3eca5ccb7b7ca5f1314aa509345376d12ba8f3bf8e8d07e0c2813d2e9e7552d2"
    sha256 cellar: :any,                 sonoma:        "29feecd8507b9573dd45436643ec29a1e68fe0445f7403cca19d00f58098b538"
    sha256 cellar: :any,                 ventura:       "8231753899657336412b7cff78b5829b23108d6c5d70362ac469d49ea43b92f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7713d2978fbb2af7345396c83fd40ed8d9b108c01c072f61d28d01809377feb3"
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
    assert_path_exists pidfile, "Failed to start memcached daemon"
    pid = (testpath"memcached.pid").read.chomp.to_i
    Process.kill "TERM", pid
  end
end