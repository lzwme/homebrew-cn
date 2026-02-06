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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e27f662efc6b0f5044a9d809a39b06d25847749e690b3ba98703e0b078a37b5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58ff14fd48b815dd44d32f3284b942707e78406bfadfcd8d80af2d294105de53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "720c5d08f96d293b1c066e3fb12e6392a68cafd71fef1d9b77fd726ddc1dcce9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee225bd3704bd542854f4cf8483bbea49af0cbaaea16ca335caa84574d6eecbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad4316f8712686d000fd817d1e79d24f4e3685309cb786af8f0bbfd9b16ddbbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7cc60a74f42ed85574ec1b4cff8510ba1848a0fc739f21552ca607ea3547bbb"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"
    # Use correct compiler to prevent blst from enabling AVX support on macOS
    ENV["CC"] = Formula["llvm"].opt_bin/"clang" if OS.mac?

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