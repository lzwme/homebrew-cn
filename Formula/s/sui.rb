class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.36.1.tar.gz"
  sha256 "0124acf93bdce79d57a6a192b732c5d2b6f6b694de7a17a305714b3015f76228"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5007008e86a693db02dc421a3ea3e8585bffe16ffa59aa9a49c69cfb45360a8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6fee0f3e32a139ea8ef7f2ee5b9c5bf046fe158ef394ffa50f2e37d144c88c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adb425efe3cfa0a3d321a5c30a2bc5f60b198023b4fcb5102a2b95c4f54889fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "a166e8a8709d50c058960f74af331c06a9a4be0e741553cf436e57c38d517de8"
    sha256 cellar: :any_skip_relocation, ventura:       "3017d402f457ba3d2b3ed3e4d07f54c22e305f82ecd452a38df07372e9d3b760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f38bb6df82c2331398a9758c3bc69572ef45fed3fbadaa8cd86e3d0420deab06"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
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