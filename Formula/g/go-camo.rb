class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://ghproxy.com/https://github.com/cactus/go-camo/archive/refs/tags/v2.4.7.tar.gz"
  sha256 "5ca7d386c5a254e67e52c40163d905730db9bdb4be3a23185c358a28eede3a6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7da3617ebf03791e3714cd126ff07d014926a824a9d6cef9098879d818d5ce60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7da3617ebf03791e3714cd126ff07d014926a824a9d6cef9098879d818d5ce60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7da3617ebf03791e3714cd126ff07d014926a824a9d6cef9098879d818d5ce60"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e041f93806e9255b1f2b5950f13926a21b9ce5fda02cc798aeb2e066e94539e"
    sha256 cellar: :any_skip_relocation, ventura:        "0e041f93806e9255b1f2b5950f13926a21b9ce5fda02cc798aeb2e066e94539e"
    sha256 cellar: :any_skip_relocation, monterey:       "0e041f93806e9255b1f2b5950f13926a21b9ce5fda02cc798aeb2e066e94539e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99ccd8dd48ef1c73129cd200ac3e8f668fa65c872ad12e00f9a24f4128da6ff5"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "APP_VER=#{version}"
    bin.install Dir["build/bin/*"]
  end

  test do
    port = free_port
    fork do
      exec bin/"go-camo", "--key", "somekey", "--listen", "127.0.0.1:#{port}", "--metrics"
    end
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http://localhost:#{port}/metrics")

    url = "http://golang.org/doc/gopher/frontpage.png"
    encoded = shell_output("#{bin}/url-tool -k 'test' encode -p 'https://img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}/url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end