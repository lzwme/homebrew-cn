class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.50.1.tar.gz"
  sha256 "c1447436f307fa90f7e1ed73f009c2bbb2a303dd39e58d5d4ae4713f0a2635ea"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fd769b49c4b621028450807fff6214e9966b7dd54724bb9744a469945c316ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6fd5a017b256b69e679ebad8497f0bfad5b03cf2e261e808b08aa0bbe97005d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8ce20e47fbf00d6c44d1a1adcbb5624d8396457160c36e6b05da30d51f34481"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8931d7925a93c4f56dd379ac297da3dab80fc03084e0e7b296d40beee6af615"
    sha256 cellar: :any_skip_relocation, ventura:       "1d0fc8f7769fa44389111d2a351c25a90d05c53c921ea39f92daba563a435b29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eb2236c4b6a13691b7ce1b254d496b32ae540bd2ddcb6cc20569a68566b0eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "367731ee180810f47db1e78836bb2b1e690e2507bb5e402766a09a8603f21f7d"
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