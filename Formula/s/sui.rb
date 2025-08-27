class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.55.0.tar.gz"
  sha256 "958d2caf0350c0a4b0572a6a065c1e61178bf4972c9bc1a1c5ad00bac2340c08"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "140289e0c5b9e828037b796206b734a1ffc2fae9025e7807fcc75f66aa2a7dc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec746e6e455a4651a6538940811b78bdf1a551f0b849a370eaf50903f5935694"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5831203d2c523bf7383f4c8c87502073ee1905c6ad8b5cd9ecf6001e9bcfc3f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d21c23046b4dd3e52e77200eab425a47a09c0f55c6429018e2687474cd3004fc"
    sha256 cellar: :any_skip_relocation, ventura:       "f6462641eae03d37285aeccab2e296b583a2e17c8eaa82cfdd977d99ab4b8f33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5316b8c849b3733858b8cf6ac470fbc95b7054841f4582ea4eee6713546c000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ebfd16d222479f4abeb833119676aed8c13799d6caab05fc3fde34657362616"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  # patch blst to fix x86 macos build, upstream pr ref, https://github.com/MystenLabs/sui/pull/20921
  patch do
    url "https://github.com/MystenLabs/sui/commit/85fe7ddbe01067637d2e771360d26675dd5fd2aa.patch?full_index=1"
    sha256 "ea19ec19ff5cb969f218363618a23afa1d3b36e8ddb04670a5fcbaa886321559"
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