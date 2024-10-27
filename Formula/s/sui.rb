class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.36.2.tar.gz"
  sha256 "ea4ff0c5c42f8949fdbfca45a038c4298709473ab07511a0b837572c5b788a23"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1df90e2a3854b627bdeed8ed90f60f64b162be39fbc488642ed74ed7f20e42a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9dcc4b6bfc5bcc7a81f7827fbfcca9d3f27cb3455e59dc6356ffda460528494"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee465973af2b7e0af88b2d2520308ebfe716cb34322635f09b7725f75a4a9bc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d5bf0bacd1865b28e5f348df64f9d37855fbd5d56125d3c05d7a2c3cf713416"
    sha256 cellar: :any_skip_relocation, ventura:       "7d7eb548ca3454b1d045e12ea3253ed9dd3b71bf424f75b3394e46e3188bc3be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41257f480fe3b606183874ef1d555dd04fd40b5f3c136a5848a1fa894810e068"
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