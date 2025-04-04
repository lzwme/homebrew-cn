class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.46.1.tar.gz"
  sha256 "ff1160078013d9cb2b0bf817cd7eed2251785960794693e2b4557e949cfb4639"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ba51f4635cee688258daa42746af331714dfe6bb563998db664ff75bb776cbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8491f2bec1a148b5423268f914a0f64b531e28d837859967daa0caa096ca772"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b8b5131765c66c05fe30872726e27f43205c01df2f2e09a9256fbec17fc0eb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "05bca4272478a039435496076fdb62c01e3be944f306817216cd12d5c24c2044"
    sha256 cellar: :any_skip_relocation, ventura:       "bf112b44f5eaf1472671e0849622849f87d9cf9f120f9fafe608006969d13cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44facbfbb3b95e5be49585a56cf251f34041240f23dfe42f9a1a8fb06c0d031f"
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