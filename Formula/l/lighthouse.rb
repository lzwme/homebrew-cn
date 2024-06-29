class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https:lighthouse.sigmaprime.io"
  url "https:github.comsigplighthousearchiverefstagsv5.2.1.tar.gz"
  sha256 "ce63b50815b0b9af6be317d1856578871ea45bb9f76b416fce010a6429dfd8b9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef4cb8ad805b1eb1ee4f4adce082bac12dade880f6491972715e9a84acd8a66f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4cdca2e0645ea6418626b2908922091c89562c6d92f460ce46c66ff83faaaa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c74c6ba5898dc357a0f041a2a391b49200a28370815fa6e2b0422e888bdf5af5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d573b86920681f9a7c3f8747c8cd167acac6b144a6b567a4cb40b13531d2c37"
    sha256 cellar: :any_skip_relocation, ventura:        "a0c72ffdcc7f4bc2dc726ced302ecc00f08f78cc1761181f7176ffd3d76f9a0b"
    sha256 cellar: :any_skip_relocation, monterey:       "52b79f5cadc3e6131ee7b98409116e575f68391912bca4c6a05d6c1e116db517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e61d4c614944440e0125408fc9985362d31ba801371c266ba91173c77bb40da8"
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

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: ".lighthouse")
  end

  test do
    assert_match "Lighthouse", shell_output("#{bin}lighthouse --version")

    http_port = free_port
    fork do
      exec bin"lighthouse", "beacon_node",
           "--http", "--http-port=#{http_port}", "--port=#{free_port}", "--allow-insecure-genesis-sync"
    end
    sleep 18

    output = shell_output("curl -sS -XGET http:127.0.0.1:#{http_port}ethv1nodesyncing")
    assert_match "is_syncing", output
  end
end