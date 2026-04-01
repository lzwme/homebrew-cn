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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f92730b5dc495881609d2ece1a158bb2884de3c292332d0ebe446ad9b0a65957"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ef8331b2a1c5c904d584818179a2142beba6c89b30e7ac4b1f0ca99933f1ced"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7480de3cf91794b3e507de53ee0b478d60236d230b995bf0a819a5e9283053ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "e479636d354125386c906a119091411c16bea6a1eb540a9556c37aecab5488e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29674f9dddced255764ff6a91f638b18dc060818c23620a4c78805119c3c7d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06fdf1eb4f4b70168c4daea0c61231b3c02fbe2ccddfce8318508377d38dcfa6"
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