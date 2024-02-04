class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.17.3.tar.gz"
  sha256 "815e6acf5756e7eeab7fb1494642e3d26a69a66da260deac8efac82c5b280771"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f708da9c0ddc37769de498e83f79b8a569184975d29c222d86c0bd27692eadb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "589fecc9c503567537feadbf0055882ccd6f2b2af80ee41e64681221ba92e5de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61ccf2a6aa49ca3b1a475c63a640a869fe32035fcc38acf64a4546561ca835c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "29c92a45be39d64e8690fcfb39da8841341b9056870a9f8b6a8fa8e11fc0e545"
    sha256 cellar: :any_skip_relocation, ventura:        "bda2362ddfaf82fd00337ca953ffc46923aa015a749c2265771961a8ee15b48f"
    sha256 cellar: :any_skip_relocation, monterey:       "5f8c001d603cb55d241d0c99f7cf94bbf2245546c3e37c3ad528a4a1837f55ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e244d59d3a2b3de66dad438537b0cc845c40e3f178fc65afc6b2d10dd6f7a80"
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