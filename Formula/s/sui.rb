class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.38.3.tar.gz"
  sha256 "d0e5829dba5298550eae28054f595678b303ca459a6a2fd699a6c732317e1784"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73734b3cb166f1d9b2e339d406090d0245a5fc0f78b6a7f0ca4750dfaa2fcbc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a3e2e06875d2289ff1de10e76d4064d102a4b3e355c7e63894d8803ee7f3aff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03c65aed4899c865eccd7006e65c6264e278e543bc2c8289b4925cb2f25a76aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "67de2cda095069d43564f8acf33cdb258d8414a18d4853db48e4ee7482727c99"
    sha256 cellar: :any_skip_relocation, ventura:       "b066fdc5c9435c8c7cfa81ea24fbadc76afaff16d81ef795291cf425def160d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "490eea68c1ed2c454a29f7ee649ce6ba58dc5a27ede86b57aa58c8235250ba9b"
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