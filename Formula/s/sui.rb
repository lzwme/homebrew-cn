class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.81.0.tar.gz"
  sha256 "0da0c7146e2afd757dd5a911cbf50c6d52afd839c8ca963a2f297eef674f091a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b946f3b32dcee7a2613bd1302657f1f2e9f2afcd25aabb919332a23dd5b2e1d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a78fb7f5fd190943792191d685917fe9a21d5ccd56b707e0013fec697e6f75a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0dcb92a4318ec67c4529d0a1c96984cde0c98c2cc5842b9775bffdf99501d07f"
    sha256 cellar: :any,                 arm64_linux:       "3d4184ff7848903531daafb8d8e8084936bc432e50cfe13db8320c6bacb73535"
    sha256 cellar: :any,                 x86_64_linux:      "97bec6b5d799a0f688d9bd2c0eebca3554d1a50a0f988e26c008cbe73f39e0cf"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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