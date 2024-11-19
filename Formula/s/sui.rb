class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.38.0.tar.gz"
  sha256 "9fb282d730a74c9b33335610251a6e5e4a33b7fdf40bbbe7797a00db24a19e43"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bdf85e13bd2a73d560223e1e237f7aac0c79094f9143abc312d62ba7da1743a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd310d5ade9dfddb800d3e628c8a950fedbe49e9cbc1fc0066162fe9b65fc547"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02cf84549f49caf78ca26565a76c782b807aeeabed175b1703139f86c233c026"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab8496d5d72cb08b8c18f3e7315716e0e9e36c1ed2b6bf8915f37ea683bbfab6"
    sha256 cellar: :any_skip_relocation, ventura:       "8f3867408213140e4368f2310c115d5d687a5d7e2020c2c6c2c060e4eed8d079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8878bb9a8e881c1aec545a2ea57d276d35fc8fad020698a4f7cbe42fe350b3c"
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