class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https:memcached.org"
  url "https:www.memcached.orgfilesmemcached-1.6.30.tar.gz"
  sha256 "d69428c8c1c08519f21555f8f3b9c2d64619dc403e40d822c8cbccce5f5741fe"
  license "BSD-3-Clause"
  head "https:github.commemcachedmemcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\.i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b3d9c2d2cf408f81c53c3e051bab9b3aef9db7d23880299222d10251e8c17753"
    sha256 cellar: :any,                 arm64_ventura:  "ce862312b0406f8f8cad509b1b4a8ce587822fc76545e92eb0a38f5323711965"
    sha256 cellar: :any,                 arm64_monterey: "1fdab865bf4fee76fae11303640883d91f27c97cc387776d6b33e2a7342d84db"
    sha256 cellar: :any,                 sonoma:         "574efe67c1ed6f86c7df3c8bc1a59f8f4a61d71898cf0076424c3a7c9a8aec19"
    sha256 cellar: :any,                 ventura:        "4cb3c25a10e538719feb89709b4aa45ae7e9b32d15b9c615703cd5bb344aae5e"
    sha256 cellar: :any,                 monterey:       "2a59f531b79ab6216d428b17df0e8068b16618582bd5ab5c2cebe3742ed2754e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "281738d087f0fa4f3e72a9bc6404014674163162d6165f30df9213aac0df8e98"
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