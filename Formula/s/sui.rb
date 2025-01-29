class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.41.1.tar.gz"
  sha256 "3ce90dfa120b8adc270c3e2c60e392a131bba7c9b77f3feee8c392daca87da96"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e2ab0691f8609636bdeb5d94478eaac591803e43653a83ba3679b526fea4caa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4adc49ea4a01cfeafe52dafc4786ee5e3a4b98fc3705121807bd2156a32f6079"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4aca7492b0b34565de04a99529f44c4ca3c32e94b9465b088dec922f96970c2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2ab7fdfa1c11256584ec0b38c59461c082edff1996b4e7e35c50ea71367321a"
    sha256 cellar: :any_skip_relocation, ventura:       "e5954a6a716849091706353de2ea2a394da6c4cba912dbb9328160ec710bef05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e121cb127e29c248b2fabda7610d0585cf907b059952d81a62aa41f9e6a371b8"
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