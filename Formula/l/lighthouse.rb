class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://ghfast.top/https://github.com/sigp/lighthouse/archive/refs/tags/v8.2.3.tar.gz"
  sha256 "be02f4839b961634d2641fd683f61f6cb5c6fab0452dcc9ef5e132014d626509"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a475622c80d3009008fe4e7c23133a15b143382b21bb981c435d4e12007de991"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "98a1c345a19f7ff8d9341266a0438595dee28d4e175f8015f5d3c965dcdc3a08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "93b2e81ce864ae9a44f42b92781b2a8522bf4f2fec714f8fae5fec66673991e6"
    sha256 cellar: :any,                 arm64_linux:       "e87a168af8097f2818a05f983731993725771cd4b03f64fc74e22a8728a85e85"
    sha256 cellar: :any,                 x86_64_linux:      "b5a3e76a94e591579f3ed665d8035b9214a436df40d282b92f88b5375ea0fc10"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "lighthouse")
  end

  test do
    assert_match "Lighthouse", shell_output("#{bin}/lighthouse --version")

    (testpath/"jwt.hex").write <<~EOS
      d6a1572e2859ba87a707212f0cc9170f744849b08d7456fe86492cbf93807092
    EOS

    http_port = free_port
    args = [
      "--execution-endpoint", "http://localhost:8551",
      "--execution-jwt", "jwt.hex",
      "--allow-insecure-genesis-sync", "--ignore-ws-check", "--http",
      "--http-port=#{http_port}", "--port=#{free_port}"
    ]
    spawn bin/"lighthouse", "beacon_node", *args
    sleep 18

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end