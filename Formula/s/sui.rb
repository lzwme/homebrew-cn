class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.46.3.tar.gz"
  sha256 "3e684f01ab01e8dd1959e22599317599a0ae0d8fdf75be73e73507ad1c3f295d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cedb77f98883b6a576c7af211d3d87ce9a5f19b3213b1af82d22a554a9a74bec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "549932bb7c4121122071de2ac3828c66faf78743bef5194f12a273303731c176"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5def0b8f500953f53c6aaed485e19f160ad2696e3307e8b5d70b5a923f8bf26f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea1c3b58d9490609b767beac5d384bfe1adc87bc59080c0a88db90d0a0258184"
    sha256 cellar: :any_skip_relocation, ventura:       "3e1881674e05aeefe8c8d5379acb791d5cfdf3a881b128c819426d174c482045"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9335e422d4e75b2c6a83cbce1948270a907c926b9256ea4dc2fcf04c3a6646b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "224ef841f63b919c6da1d8f398e5267680da42654247e4ea7a6369e167208708"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
    system "cargo", "install", "--features", "tracing", *std_cargo_args(path: "cratessui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sui --version")

    (testpath"testing.keystore").write <<~EOS
      [
        "AOLe60VN7M+X7H3ZVEdfNt8Zzsj1mDJ7FlAhPFWSen41"
      ]
    EOS
    keystore_output = shell_output("#{bin}sui keytool --keystore-path testing.keystore list")
    assert_match "0xd52f9cae5db1f8ab2cb0ac437cbcdda47900e92ee0a0c06906ffc84e26f999ce", keystore_output
  end
end