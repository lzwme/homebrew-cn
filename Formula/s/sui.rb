class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.80.1.tar.gz"
  sha256 "c658732c19dc584300025931aec36ef9b4a4f9044de85bb21113bd3db86fc856"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8cb4c55a8d27c9ae90b8f2abcd7e9dc66c6a9cf25e43fd1091356f1babb1b05"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c7072109102bc8a05c8cb6ddc0b9213deb7881260a9e3a500377937cc5d523e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8746f28ae6685b854a4c156b6779aef8a3abb2f110566dba9b86eba87b8fe7c"
    sha256 cellar: :any,                 arm64_linux:       "72e8dc46d438be34772ca91ba25c0fca68bd081c371a94dc30d08c0c5f87f14b"
    sha256 cellar: :any,                 x86_64_linux:      "b85f1d98d3c58b94900d3da9dbb5f52eddb5845b441f382ead1eed0c7660f001"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
    system "cargo", "install", *std_cargo_args(path: "crates/sui", features: "tracing")
    generate_completions_from_executable(bin/"sui", "completion", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sui --version")

    ENV["SUI_CONFIG_DIR"] = testpath

    (testpath/"testing.keystore").write <<~JSON
      [
        "AOLe60VN7M+X7H3ZVEdfNt8Zzsj1mDJ7FlAhPFWSen41"
      ]
    JSON
    (testpath/"client.yaml").write <<~YAML
      ---
      keystore:
        File: "#{testpath}/testing.keystore"
      external_keys: ~
      envs: []
      active_env: ~
      active_address: ~
    YAML

    keystore_output = shell_output("#{bin}/sui keytool list")
    assert_match "0xd52f9cae5db1f8ab2cb0ac437cbcdda47900e92ee0a0c06906ffc84e26f999ce", keystore_output
  end
end