class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.74.1.tar.gz"
  sha256 "7bcb5e3f19f97f84a7e7820b25d7da2724785ffedd2971861ba8faa6fa4dcf19"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2a6b10539e179ad8563bf6b41d13833d063c36521e4b06926aded0c80e0b23b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5181dabe865ca915a093f66e1dd6916a7dbaa6b1219dbd096ed44c57c9302d7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "496d018b9643ff2fa3b1d7887e3114b26e7444201a5ecb6f653a9dfea4bc7ccd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ef9eb8737a3fa2acee0b90ca0f70efb613203b68c0d12b86413e9cc11f1fd6f"
    sha256 cellar: :any,                 arm64_linux:   "3f19c87000150529ed823cf50a13299727ce91d38b4f590ba97dde0e6030a4e3"
    sha256 cellar: :any,                 x86_64_linux:  "ef2743692ffbfffb730d457e6a4a994d84e03c1bf30db59f5379e8568dd2d383"
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