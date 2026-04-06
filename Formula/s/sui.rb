class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.69.1.tar.gz"
  sha256 "c5d81f217fd568d8d62c96ae4cf2a232077b6660b5289261eca2eb3935dc038b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0993586e9d995fc38c5df83618953e00b4973d4d115ae30e9e80cc044c030749"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e296fd0d485194dca6f7ac3517acf023dd9a963b3a24249ba3b6626793e3af9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fb6cd0e63822a70acc1846148ab6996684261a14bfc4e79324d8ab0dfe781c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "72634fa867c77d410eb2a1d2ead1cedff660b52dd4dd35e8d64cdfa07b451a3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41cadd3bed1d577ad4afdfebf7371235e5b216a089d5c221da8d12e8716e425b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac7fed19d9e9b1a95d0ff6c7e8a6eacd250ba19d8574fa93a89d8c67c06877b1"
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