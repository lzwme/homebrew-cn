class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.82.1.tar.gz"
  sha256 "9e4427d3e7eea0461771dd485be974af6d08e70acfc5724f4884564194867e84"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d716759abf82c932085afc3fbc598724968802b579a918329d42492d78adef71"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dad10baa98e794eef224431d428aacdfff7d18bbecc1a29067a30ff1e8dfc076"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45e8196b8258264041e7cd8407e642744337084b54c0ef187323e11e98d88ac9"
    sha256 cellar: :any,                 arm64_linux:       "5b1f865c8240f53863226f2f5b5488b959f3f7268f7a41a2b9a8a4eb486a9fdd"
    sha256 cellar: :any,                 x86_64_linux:      "ecce24b8e7e7eb439bbca30ee9dfbd20f145461e0433f34aa6e98c2fb3c05c65"
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