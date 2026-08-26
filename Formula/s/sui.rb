class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.78.1.tar.gz"
  sha256 "764399c7406fe77975ffe7960d51545b04e96734c0a591981017b97432de6965"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54b63183f4b0b6d1e6b46846d470952870543522724683b5d0ba7c0f4b5cdf6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4893f714c8a1b858bbcfa8ca496467c58bcd19afbd4d167bf085d0fe53593e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "208a5565b201893a5d997fe61d4fb375229ee61fd266db4a61a5cb703ec52dea"
    sha256 cellar: :any_skip_relocation, sonoma:        "f49db82cd95e2a9f33d27f85123eb894519032d78a7fb2b3626c0e6074f92592"
    sha256 cellar: :any,                 arm64_linux:   "579085716839d082e0e32ddb2bb7578a3cf952bf4ad3d44d128d90516a1a1720"
    sha256 cellar: :any,                 x86_64_linux:  "1faab9f00a0eabf541a62deb05201cc98abcdfcf7bca99850fcf996d205a22bb"
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