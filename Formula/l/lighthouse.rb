class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://ghproxy.com/https://github.com/sigp/lighthouse/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "5ddf5ff22a003bb720c3dd726f100e4965deea5fc5747a613a1db4b10cc18300"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8af45593e953abfbab93adff9405f36db0e20a7c2aa187bec545d582a9f5afe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c9566f308129a80d3fd5df59ffbd5e3a24e72f035420822c29c92c065c42068"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "503550eae2c0810534fe62f0a011acab17a1ce8391effd2102fe4f3d23b5494f"
    sha256 cellar: :any_skip_relocation, ventura:        "fd645b81b4de10d1c1a3c1da96edba26e24b0c926b5750ae052d1070472fe65f"
    sha256 cellar: :any_skip_relocation, monterey:       "6ca80664709cbcd13700595d2db04e63d65a70e71a017e98e58451b2f669057f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6469661bda7ad1fa12c21655133882e7a96e69587398c553e34620dc0eaf5449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "309d882c069ec415b4a5b86f556383b24be961f9f4d10362320b1179285712d3"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
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

    http_port = free_port
    fork do
      exec bin/"lighthouse", "beacon_node", "--http", "--http-port=#{http_port}", "--port=#{free_port}"
    end
    sleep 10

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end