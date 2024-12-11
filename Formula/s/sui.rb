class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.39.1.tar.gz"
  sha256 "7f1f0f9266a824321ccced85596253c58d911df34b5094cbff1bebf676b09e3e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a0497ff34a075b779367f6b1df89c1b3571ff2736d493dc31446fc8a2e44b2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4932e6daab2ef91a63d4533ddd1dffb64d56a3d733c03a226f97c9c097d3d738"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe593c35aca5c05e7cb1ec7ec324e4a6b3ee6647defe1a60cc620c93ac9c48f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7a50271464f2cd56fdeb241d8bde11e8127b5fb8bf65458e9b4f645e62b4a9f"
    sha256 cellar: :any_skip_relocation, ventura:       "c6d466c3abb31e59088f08a17a7c604fa481eabb5fea1e88dee161855309df1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2db5a41914d069cfeec24eb3c56b878cac11d9a0728621602d80ff51c7ebe5e2"
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