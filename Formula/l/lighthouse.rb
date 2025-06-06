class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https:lighthouse.sigmaprime.io"
  url "https:github.comsigplighthousearchiverefstagsv7.0.1.tar.gz"
  sha256 "e2432feb02d6dd86faec3831731a88993c428a87df1fa6a43efd576bdf01f259"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c8f0c2c51ee1961024d86aeb87859bad341c93e9dcee2956a30e672dfbe63a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5bbd70f9c3e66b211a32589278a51eb41539d872de75441939a2bf4a491963f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f2fc91dfed84d69d34b28716c8656e180d2c46f35055db2ddcedaa2627e9ec2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef23deee081e1be5d482a7e2f1d388c0dd85325a3391d840db2ce3e6229881e5"
    sha256 cellar: :any_skip_relocation, ventura:       "0624c275b75ef888987ff09bd2ff8345b91acd5def5733d23248d369b2b07144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f923651f0167d38fe57e981c636ce61c72712812a37833069999dd8f523f6552"
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
    ENV["CC"] = Formula["llvm"].opt_bin"clang" if OS.mac?

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: ".lighthouse")
  end

  test do
    assert_match "Lighthouse", shell_output("#{bin}lighthouse --version")

    (testpath"jwt.hex").write <<~EOS
      d6a1572e2859ba87a707212f0cc9170f744849b08d7456fe86492cbf93807092
    EOS

    http_port = free_port
    args = [
      "--execution-endpoint", "http:localhost:8551",
      "--execution-jwt", "jwt.hex",
      "--allow-insecure-genesis-sync", "--http",
      "--http-port=#{http_port}", "--port=#{free_port}"
    ]
    spawn bin"lighthouse", "beacon_node", *args
    sleep 18

    output = shell_output("curl -sS -XGET http:127.0.0.1:#{http_port}ethv1nodesyncing")
    assert_match "is_syncing", output
  end
end