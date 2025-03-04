class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.44.0.tar.gz"
  sha256 "112147305d7a7fb6e27733700a06d340883372e2bc56c253ae8226f67fcffddc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ab0e809f8d5b27b535898a920534140460f702f9a6e93bf018c056f04bfcbc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59c2bef16600e49e68a87c218dd9786d618826926cde553cfe735ade7e9b5d52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "252e4c6bbe5c12a0f77ad466bc7d426d7b2c70a0144135d5d6c6d1d6da1cec59"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec9cf0539477bee456ba36db298bcfb7c884d6cba56a43e5072d8473339b2427"
    sha256 cellar: :any_skip_relocation, ventura:       "938f3d3e759deae1d2561cc5447ae7027604fe6552987eb4c016b8c857b2157e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07eeb76558f7cec4c601068de858dc9aff3768a24572f74c74922e469922fcc8"
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