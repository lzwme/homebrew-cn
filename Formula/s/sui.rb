class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.38.2.tar.gz"
  sha256 "dfc966d9526e613bb25f8f109410d40229e88f0817dd8def7a8e772112fe3381"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "363e5410d5cacbee9f850f663061b4f595e5de6a26f7f8a99800b056dd0cc051"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45e4b6b04a39e21864d612557930438366542863f1031c07e43a55ba1eade781"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e37a31f7e6aed434754c26341cc2c6b3e3664773f49187030bf31b5cf6229da2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fb2124f63ad11a642f59c61b87dfc4d3376e0a4af5e4844914d9c30336750f4"
    sha256 cellar: :any_skip_relocation, ventura:       "7c15733fa266107a6355243e549e4e22630e6e9dacfd87789f3ad92f7deb3ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "214b62acecead6d19d6cfdc6bd0eb6a165629fc066c3a8af5aeb4df4203c612a"
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