class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.51.1.tar.gz"
  sha256 "f51673f7ba032a6c762d6a07d10d078c784c72a6eb69114d768da9f292b956c7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9996bc1f25d448e4a857aab11a507a3306f91871217387ef3b8c72a38ca17b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0daef6fbd0cdef8c3af6150f42f721662995ea99e6c37c92d47dc6e990c193a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90fa381281d8a4b0e6a3c7202261f5ed9672e221904126fd74cd00f61e5af61c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b0ece9c880b66926c9cb13e9bab3da4c6e7b379411823926000ef271ff1602f"
    sha256 cellar: :any_skip_relocation, ventura:       "d2f825667485fce8c503c5b474788263dc48b064233842485d1d3479d5096132"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30a1c03f6c103785fd14322249de1a459b63305285ff44e007b4b07103f06fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8112653d800b4be4ccb90eaf852ff6a4ad89d72216977f17f0e7a25ca0138e65"
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