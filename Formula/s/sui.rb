class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.67.1.tar.gz"
  sha256 "3404382d552f4c28b281f02526ce2a776b12927b87be9b3c0624bd2044e8ae60"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb87bbd23155ca13eca20c108aa32672d625cc995ba447f2f6d8e0f11f5ff9fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab3122241950a228fed4d10dd77de9bf562e000b92cccb580d0b45ae104fab3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "978c3ca8950c98d9a25304e10fa04e10d54e1635bfcf0baf0ac619f953331bc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "abee3ebe216537b5834c93558c93a060c1a98ade4a10a3a12c3b37eb4b67c6b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "240afed19d29223ce827f65ba596785bbec566e5cf85462093b32bbc67f3eb61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba6704bd69a860365cbaf3624a3cfaf5fc159fdeed5beb8efb32f2395ce0a380"
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