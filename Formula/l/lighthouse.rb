class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://ghfast.top/https://github.com/sigp/lighthouse/archive/refs/tags/v8.1.0.tar.gz"
  sha256 "427bab4f400967711f172f2858ce21db365babd82812cccedd30f01cc9cbf830"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fab8bb11936c7f242540f4c4f1f99f5c137e64d82b65eaca32ca3151601e996"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a37963e36dc7100b83f8fd8f8b7db4bcbd444239090729b058105139a5201f76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb5aaf5770e8819e0fe2a74a8182bbee260c8898d7b3ec9a1a42f81646e056ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "75cb4b9e6060d459ecd7dbd776a2dc2185e01f193a90dd98a5d211fb7c59e6e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a12805e2a91dfd1e2f85d252ba14d7595f1fd46d017ef3c348a4c0abf04ea8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e93036cd2ab3da45efa1bb6fb125cda9df8308b120206f9efa1c82817e56ecb7"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "./lighthouse")
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
      "--allow-insecure-genesis-sync", "--http",
      "--http-port=#{http_port}", "--port=#{free_port}"
    ]
    spawn bin/"lighthouse", "beacon_node", *args
    sleep 18

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end