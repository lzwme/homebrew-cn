class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.42.2.tar.gz"
  sha256 "1c5ffe54d4498729aeb33a0fad5169133050bc3d07096c254b1f4bcde21d2ae1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42f953dcc641c0f2d8ab55ea31d2448f1fd36aa6e4efcc9c822a980a73f65cac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fa3729918b46a7f924bbd3ad83542ddb89904a9735f2a6fc9c6b310b7698921"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd51d321048f4ea4da3fef3302e979128139f5974958ae49cf4674daea173588"
    sha256 cellar: :any_skip_relocation, sonoma:        "839ab8eb4aaeff0cc7fecb2872461cf47e2cab3c64c875e8182a5a8e005c1b81"
    sha256 cellar: :any_skip_relocation, ventura:       "9565c2610e2a693704ecb689c106aa7895e2a33fd08e98608ee287e0f7cf08f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b4f18cc371e21e6b1d72c34c3289bb960f12977acf695cfb992f806e1202790"
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