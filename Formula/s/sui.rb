class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.67.2.tar.gz"
  sha256 "80abc1a5310de9c4635de5a250b4206964eb4e6b0a628ddc2f719aaf95b7457d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0038621f350ea6bd9399fd6a1fa7d764c0e6221120fb03fb05f0a2842b0bf130"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56e8be5bb4680685fd4d6ebbb27c43ff5712b56c67296991833ca4abcaf0858f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66a7152d36a8f8dcad5d95652208c08d0480c3ade5c9bbfd521fcf31b0450b17"
    sha256 cellar: :any_skip_relocation, sonoma:        "767f975256a4eb5493552f5f822a992f1d7e84ce373cda3cd9196b4d85806fcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4622caa6ba1e13cd9a01d5471ce0484ad727fd39a83e495964d3c66c776cdd56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e7106515aeda31be35fb68e091935de231c54df094920f5a86d583fb724e93a"
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