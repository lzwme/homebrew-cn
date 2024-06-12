class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.27.0.tar.gz"
  sha256 "80964c4d702f5c440a5b097aa3ce78c7b52848ee718e51464485ae374846e5f2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71fa6dfb8a78b98e2811d7490dce051fc4fb588cfc893e64490a406e3e7918c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "002c26fb1ac2c5a4620aeeece06d601a6b850b3dc58f9592f504335bf2fe1af0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87603ccd982fa0056d560ca3ca0873d3e1ed52a80ddef3a9b4b6c60c845d79bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ec36f3ce9cbb4e7be752a86a996b2295c9faa02e7707bc12cc98173d395c7ac"
    sha256 cellar: :any_skip_relocation, ventura:        "bf5541be246b06ff507b03d03952ca2481f8e538840cf5f940aa77980fb74fd9"
    sha256 cellar: :any_skip_relocation, monterey:       "79554274e9f36855fc23c67ea2691bcd207da91649b320995469fdc2fe9ddb01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fd223992a9f18cd056efa3cb8973131bab4836cc259dbc72f77890333b8d052"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
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