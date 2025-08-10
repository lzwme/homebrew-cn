class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://ghfast.top/https://github.com/cactus/go-camo/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "c5c2247fc12115e5d55ef258da64a315d9275036fd6f688906f9fffb12d4a17c"
  license "MIT"
  head "https://github.com/cactus/go-camo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "808e1aad4ce23223b61e85d48b353e80c3f883d3343180f8d038e9357baff009"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "808e1aad4ce23223b61e85d48b353e80c3f883d3343180f8d038e9357baff009"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "808e1aad4ce23223b61e85d48b353e80c3f883d3343180f8d038e9357baff009"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c342da683d3795b03052ea7840579d22a76d4d4e64073e60cb54ff668d4cfff"
    sha256 cellar: :any_skip_relocation, ventura:       "0c342da683d3795b03052ea7840579d22a76d4d4e64073e60cb54ff668d4cfff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bf8f8a72af8613699c6570bf9ce409379b19986e263677d112ff3eec71ae19b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "903657e4418ebe582cd8402ab2fb6816c4a3ab4ccf5b69e6d572044a695a85b2"
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

    url = "https://golang.org/doc/gopher/frontpage.png"
    encoded = shell_output("#{bin}/url-tool -k 'test' encode -p 'https://img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}/url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end