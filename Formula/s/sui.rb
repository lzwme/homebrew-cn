class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.81.1.tar.gz"
  sha256 "25f3aa9bb99717c0ca2d8bafc43858bbfcfe87e0377f768f9f743700aa52b615"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eb44324d0cafb9282a11ec7533efe4dab37d65f8357ce4c36d6670d2706258c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1210ab9f4a67cff12316b299d4c577a73a7b0900c97e66c3487bd97798ae672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97fb7f0a63ae5b6b284e33647e2831f1dfda97b37c2924603c8bbb173a458e65"
    sha256 cellar: :any,                 arm64_linux:       "36b52b6454abd7183f81b87cd57c1c139b07e628263bba90f52d29bce77b20e4"
    sha256 cellar: :any,                 x86_64_linux:      "0f61c8b9967da548f0402fea65617de1f94fd83bff2ada19e6d382d3686089ed"
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