class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.59.1.tar.gz"
  sha256 "e500bef6fdb5071ca979b5a16812c2e9adf78dfe4ba86104ce1bc8cd9da3a691"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aea25d33ecc9b08473d9be7f6e887cc07f4e429692f4847a34134cdfdaedcb06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd645846112e838a4318000e58228cbe2974208b15172f11b2d22d7b76d79c2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5899ecc0d3bda131788782a4268a5dd98d94b4d1cf3b7e8abf0f37b056d35e6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2113f0c4f42b83ea698bc91727414e296ba7dc36f53949032edae3ff60341128"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b87ba2677fe3c26cd672d6b7b5e38d557a8aef76f6f5c4dcbedd27e3e4d5b8ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "409dff664ab11f7ec383b1209c04f5ad8bc75e41b40a7c88a710a5934bd75639"
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

    (testpath/"testing.keystore").write <<~EOS
      [
        "AOLe60VN7M+X7H3ZVEdfNt8Zzsj1mDJ7FlAhPFWSen41"
      ]
    EOS
    keystore_output = shell_output("#{bin}/sui keytool --keystore-path testing.keystore list")
    assert_match "0xd52f9cae5db1f8ab2cb0ac437cbcdda47900e92ee0a0c06906ffc84e26f999ce", keystore_output
  end
end