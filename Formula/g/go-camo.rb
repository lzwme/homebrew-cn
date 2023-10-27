class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://ghproxy.com/https://github.com/cactus/go-camo/archive/refs/tags/v2.4.6.tar.gz"
  sha256 "bc0ac24978dabc9a37b191f9a0ef36a5078009d2d56f823c299caf89e1fa5d14"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9003c3addd7fababed200b5aa571d6fc5b7382a55a0ab4dd78412fbc3a496c0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9003c3addd7fababed200b5aa571d6fc5b7382a55a0ab4dd78412fbc3a496c0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9003c3addd7fababed200b5aa571d6fc5b7382a55a0ab4dd78412fbc3a496c0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "205f258aed826a00465b4af35af2b8be4d32a29b76c8a6748604e019cd2089fd"
    sha256 cellar: :any_skip_relocation, ventura:        "205f258aed826a00465b4af35af2b8be4d32a29b76c8a6748604e019cd2089fd"
    sha256 cellar: :any_skip_relocation, monterey:       "205f258aed826a00465b4af35af2b8be4d32a29b76c8a6748604e019cd2089fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8d733b5a7c2f141518028c794f3a2b8c88c768316ddd439c0ff6fd46a90d8c7"
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