class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https:memcached.org"
  url "https:www.memcached.orgfilesmemcached-1.6.33.tar.gz"
  sha256 "707f74c4c6876b61532b998ca8f118b0b82a0d96365d7a1d70ebfc40dfe83dad"
  license "BSD-3-Clause"
  head "https:github.commemcachedmemcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\.i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6984873dfe4cd4b14f3abfc99ccc9c69047cdf2c0889f593ceefda4c825d492a"
    sha256 cellar: :any,                 arm64_sonoma:  "127dfa6e5126c76e7dfe6cd3073edc2b6bbbc5b0a09ff97efe1e610223caa4ec"
    sha256 cellar: :any,                 arm64_ventura: "f2b3f24b5d0bc03c4f28523d9f0068f66bcbe36aaedf5adbc34caaf7fe757fde"
    sha256 cellar: :any,                 sonoma:        "26f7ab03c6043740dcd3fa65655a790a5104d859bf77b710c0645ce377d8aa94"
    sha256 cellar: :any,                 ventura:       "d92a3502c222013eb732e1b1cc61b0db054c5d3d25559934fffe5c64a2ff39f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e85a52d00cc334e79d9a04a504ea064fa4db383697781e4556dd1696185eec24"
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