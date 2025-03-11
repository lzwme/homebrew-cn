class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.44.3.tar.gz"
  sha256 "337a5eae90cbab6cb1aef76fa966f8e4adf0ca5741fea9f5679eabf86233537f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64dcefd0ca143530486478f81c28a5ac00a567f0bfc21f07d40012509d898f99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec106fc1c6e4c75900dd3cd426b866f342dfe1ee0583ef71efedf42f99f6751f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1625b536670a2b59eead7cbb3a12712ecc42a6fbe9f4ebff96debce118bab7be"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6a078edb02dd8be23b1b4597b832d0cc8b6f5f8c6321b128f466cbb2cb22184"
    sha256 cellar: :any_skip_relocation, ventura:       "dc69e520840202c93472a5aa2f8e406909fe4cec54a4e24cb4b0e43a2b55827c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f6812491d5268a38c668d0e2c2dd212cc360b1c3301d7a5d22260824a5a3200"
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