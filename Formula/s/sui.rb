class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.70.1.tar.gz"
  sha256 "8d78b817ff63e6b70855818ce79fc5b7ecc3dc11e370cf77b8af6a8b1519a4f7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fea738a499bcbf109874bc376de930f6775a763b7134cfbb0398a0fb8a0fc3a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c805edfa9badf1e8929fa9cebed05bac41a6333c07dd62581b7829248ab8d1c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1abbda97b4d89daffd727464499fb256ce85ebe83b1e021a342d047083967e5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "19d5f18222b709f791e37f46497c6ded4f39d2a93abe1dbaa855a72986cd4a76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7b04de120145c4ae54232dc75fa2049441e73233454af7b8350a2465b0db0f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab1d305bb49460ed36b49ec53e03d83607c36aa2c86d4d85a1650722a3ed331"
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