class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.66.1.tar.gz"
  sha256 "86447f812d4c44504a2fe063fcbb0c7b9962ab8036445faaf6844c1fb60be406"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1aaf6cd211cf0c3d9c28ec00fbb24e4f17cbcce6a09fea5a60b918aa98a22dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "864fdfec09c670ef539f7182579038efc6baa8e45b0d0814b838d7c8af9c047a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffdd586ccbe5e945ceb4d7fdc5b8451a92bb248201f6bd4f23fe2c4235c7dbbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "256164b891f7dda891b4c75dcf4c5da9fb57fd400a701f0d14c23682c36997de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48e9c68a70ad606b2cb46ee3c850414cb7fd22243badcb362b7d7f777fe47aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1f144d8f59c1200346fcd86cb6c0eac717d3bc240d76354763f7fc13e6d358d"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
    system "cargo", "install", "--features", "tracing", *std_cargo_args(path: "crates/sui")
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