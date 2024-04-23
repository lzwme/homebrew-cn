class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.23.1.tar.gz"
  sha256 "06176389c163cd99ed6a78239b1a995e2ee5684ae5ae9adfef80c9662256f47b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a28c87a22a71b537d33dfc11d4a2fd123f4677fd09a31d75b1776c559242474"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22d50f5f6cfb93c034edccde721e666643bbfe60ea90159afd4243a8de041f27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9253314cc5713a1691a9fbbcb4785e8ebcd2ee23c07c38c7cf7a5278109616d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "d583dc0456e50f42569097675951c2a7c97d477ad5c77bd67a20ee80230e6e95"
    sha256 cellar: :any_skip_relocation, ventura:        "e4983d0363c74dc251cd64705b27a6b5827c21b0fc44f5c696da0ad9a7784ca2"
    sha256 cellar: :any_skip_relocation, monterey:       "6208219a29e97d74ef76378c6fe15dfe0427e5df60b852d82fa49bc9f2aa59f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b8818c4a399df210b4f6bfd73a65a78bb03779604f405fd3c88e199e3e0648f"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratessui")
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