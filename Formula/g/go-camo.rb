class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://ghproxy.com/https://github.com/cactus/go-camo/archive/refs/tags/v2.4.5.tar.gz"
  sha256 "8a9e64266f6809a01df7a3089c311978004cd066c92ce96b7b09b786a1d27c97"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3ffe16387678a0122ef9cbee954c16455a9e00168dd98bd07b956b47591dcd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3ffe16387678a0122ef9cbee954c16455a9e00168dd98bd07b956b47591dcd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3ffe16387678a0122ef9cbee954c16455a9e00168dd98bd07b956b47591dcd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "88e4df7ba1c356cce6689ebbf363ffedbe32097d924998f6080ba772077c87c8"
    sha256 cellar: :any_skip_relocation, ventura:        "88e4df7ba1c356cce6689ebbf363ffedbe32097d924998f6080ba772077c87c8"
    sha256 cellar: :any_skip_relocation, monterey:       "88e4df7ba1c356cce6689ebbf363ffedbe32097d924998f6080ba772077c87c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01e2e715963ce5828e81737a84fdf28cbbb93a7033fbbac8d53dfc04fac53168"
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