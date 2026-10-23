class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://ghfast.top/https://github.com/cactus/go-camo/archive/refs/tags/v3.0.tar.gz"
  sha256 "c6a09edc5d22f5b5277633db48a36a2dec169f9ae2a392577b3e004943b2c322"
  license "MIT"
  head "https://github.com/cactus/go-camo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f36a96c8838738c99dbd138a5353dbb2245d5842a9c78589511ed1848dd901e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f40ea5781c207f1f2a84365eff2d54518217e6119b7842e9544c54020d1d186"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "318fec8473104d36f6576412bb5bab1a3dc08024456a496a828058810b8f2fbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b1916f7e4ccd48a7ce480db9f304a9696d8dc7cfeb44b3780a486fbf7f256bc7"
    sha256 cellar: :any,                 x86_64_linux:      "bb5813af65e209c707537c6ab6ee6086ece83f111a8f2b4c4a235bc74dc434e7"
  end

  depends_on "go" => :build

  # Fix metrics startup panic, upstream PR ref, https://github.com/cactus/go-camo/pull/90
  patch do
    url "https://github.com/cactus/go-camo/commit/d23a95e720114fc85802e4c37200d18cd23f8637.patch?full_index=1"
    sha256 "4c89ffb3c58626c08fb883fec1e45e99ff86105700a0125ab31cc1ba57269ab6"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.ServerVersion=#{version}"
    tags = "netgo,production"
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/go-camo"
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"url-tool"), "./cmd/url-tool"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-camo --version")
    assert_match version.to_s, shell_output("#{bin}/url-tool --version")

    port = free_port
    spawn bin/"go-camo", "--key", "somekey", "--listen", "127.0.0.1:#{port}", "--metrics"
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http://localhost:#{port}/metrics")

    url = "https://golang.org/doc/gopher/frontpage.png"
    encoded = shell_output("#{bin}/url-tool -k 'test' encode -p 'https://img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}/url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end