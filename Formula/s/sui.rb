class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.73.1.tar.gz"
  sha256 "4ec0d82ee1464eb9486b314bfd3481b603e135584d2c7e085d8b6941d0ce64da"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc4830f0efd2c2d27667c407f23b65e95ff209b19493aa7535e5186b6ec9612d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47a6e7883dcbb2eafcabe2add036e20b59ed169c015b4af482d53e3f1df1c126"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ad6faac4c6170a5c6c40ebfed0bab0b64e05106ae738c2697c7ca1331961f6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f020fdfcc58f03072323ae11e5ec9e28fcc488b804f4f686b03cc4bcbe303c5"
    sha256 cellar: :any,                 arm64_linux:   "060b2055f37675a5cf69ba937e21f45c0e827644b2689c93c72bcb4769a3e9af"
    sha256 cellar: :any,                 x86_64_linux:  "314e1c7327260fb6c0f42874ee16413161fa4865119cc56b2ca75e692977bd0d"
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