class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.76.1.tar.gz"
  sha256 "b3d54dd57674845815f5ebd6f2e97389d7bdc621e5fb29f41f3e96ba4fd53197"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "071b236332b4266c2dc50bd97ca2c9caca5e875d4ed61fbf4ec05cdf4373eb3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b879164bf31512f5ff0fc570576d89c1c48cc4e38363d0027be2f6d54016037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2e94ded289f360627287ab693a3f0eed5212814dc5b2b430bbeb087d789e97b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d7cfa5db3702b1513d103137d44c2fde114d2f9cb0b9de1bd61260d51094cf9"
    sha256 cellar: :any,                 arm64_linux:   "05775ba7dc2d4118817d765e7cb40b92cc5a4fda3aef5a188443800fcd200fe8"
    sha256 cellar: :any,                 x86_64_linux:  "60eb244f8ed8b497791eed49682ee6662f09627278c7aede1b576a8ec9a6bf89"
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