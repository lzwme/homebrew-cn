class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.75.2.tar.gz"
  sha256 "271f5fefdb5b71fe512c86e60d6f8888e47fb532d90f946e6b7b31d2ebf5bcda"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "033db508d4690c000c28a190cfcbbc3a7644b6704e5555cdda2d571483e28063"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f9746ed79a72fe7fcd2fa2774777d527d2d37d08910934bc329311f631aabab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd058712f66c18c71d8b06212e9bf2a4299504ebc7cd266a6669c2fea1dfe75d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cfad444ed0416b69f8e2419ee83e43e4a2defa5f95c4e8f6c804f49a7bc39cf"
    sha256 cellar: :any,                 arm64_linux:   "64bc657c280c49d9f8a390fccd1f075458aaf172df196492a91a6aca37306fe0"
    sha256 cellar: :any,                 x86_64_linux:  "1e492619f429c6de9537c048a8ddb2106a0b8d9da8c1dd7b62343d9c5faaf5cc"
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