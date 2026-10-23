class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://ghfast.top/https://github.com/sigp/lighthouse/archive/refs/tags/v8.3.1.tar.gz"
  sha256 "ad14be3c0ae49c0f910fc1dc2cf26aed52200f81c66fdaa2df67c7cd8fa93392"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f317c728e6e455ff3c35c4803658d29c87c9a4d49e577d0c8e5c4aa339df3de5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b0ac24f6df554bd012a0f43178cc7ab0618853370a5456dd97cbe6fcfd3a4e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3207e4ba322f2de6fbf303d891b14f077e7bd9140ee719f30de8c42b94f225e"
    sha256 cellar: :any,                 arm64_linux:       "ea3e4b9e2cad6590720f62c6dd4f87c703960486bd9aa4638420378fd8b1c420"
    sha256 cellar: :any,                 x86_64_linux:      "ff0e37f4479b53e823ef75ad0acb2c225de5f15b20e315040a5bfb3bcde98b06"
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