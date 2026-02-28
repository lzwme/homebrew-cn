class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://ghfast.top/https://github.com/sigp/lighthouse/archive/refs/tags/v8.1.1.tar.gz"
  sha256 "a2593ebf23d17f9b6fdfcc5be14994f406b77f29ac203e520f2f27d3612436a2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a31bd3cc9f5e1abab1a8467f94ad42dfe2d495b2b6ef8d86867dde96dfdc342"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6af4cb14c489dd55bbefe59a0871a9efb2b26a55d03ca9e07c2b097612303cdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1663a9776e6a7790a6f03017304571d45178ffe63322b97c1d67e16da5840430"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9b0a054869f13ba58e37120ab746830877fc03128c220a9585fc68e23ec5088"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd475b6b200ff2c20bd7a216c9f1fdee3dc130eb1e4cac580308182796291b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c012f624a368f14f1d9544b6c4e6f9f433d635cdd721093b2155349261989f8"
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