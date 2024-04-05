class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https:github.comcactusgo-camo"
  url "https:github.comcactusgo-camoarchiverefstagsv2.4.11.tar.gz"
  sha256 "aad1d60112779aed4643c69f83feeb83722578986f3ea12d5b74d1f999c1f0c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8518fa5cda3bf97a38cb0fcf860c2395416a570ccc702cafe235544dad3a78e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8518fa5cda3bf97a38cb0fcf860c2395416a570ccc702cafe235544dad3a78e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8518fa5cda3bf97a38cb0fcf860c2395416a570ccc702cafe235544dad3a78e"
    sha256 cellar: :any_skip_relocation, sonoma:         "38a1f5f4d87b8ab3483306cd5d2a8c78fec415e9efb93e2a2af9a15eead98b52"
    sha256 cellar: :any_skip_relocation, ventura:        "38a1f5f4d87b8ab3483306cd5d2a8c78fec415e9efb93e2a2af9a15eead98b52"
    sha256 cellar: :any_skip_relocation, monterey:       "38a1f5f4d87b8ab3483306cd5d2a8c78fec415e9efb93e2a2af9a15eead98b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6a1d61f2cfd083f9f60e9bcf311f4d76a40a27e7cd898b9ea427ef4c4338965"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "APP_VER=#{version}"
    bin.install Dir["buildbin*"]
  end

  test do
    port = free_port
    fork do
      exec bin"go-camo", "--key", "somekey", "--listen", "127.0.0.1:#{port}", "--metrics"
    end
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http:localhost:#{port}metrics")

    url = "http:golang.orgdocgopherfrontpage.png"
    encoded = shell_output("#{bin}url-tool -k 'test' encode -p 'https:img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end