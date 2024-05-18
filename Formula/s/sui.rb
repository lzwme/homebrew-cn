class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.25.0.tar.gz"
  sha256 "f1d464b900cd0ab426223d838a266f27b88538f296cc4bd006652ac1df178c64"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd94136daa279739885507b7e6c2cabaa5abbae10f3ef1263aaa7ce47a6c4090"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ffd2a5835f7b4758db9c3fbea1698bcb4669ba6428d5eed4df1cc4f1ed79273"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b15fc015ba5b8744e96eb561bd84fff15071e75bdbb9c239e4181478a2764d90"
    sha256 cellar: :any_skip_relocation, sonoma:         "f399a67027dc3029d46c00193e818a760cb083637b3c78026a75c5ad703e2ca9"
    sha256 cellar: :any_skip_relocation, ventura:        "cf376389e9f23e5a04f543b5034d2a77a7815cf1b7f4fa89b825c6b4eb440eda"
    sha256 cellar: :any_skip_relocation, monterey:       "2e846ce4484c961814f0f523a502436d9b36a788ff56fa0378f8db74099ac449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e991cfde9fa29d31e8746643a7ee61c1539a5a3af672a87cbe3332a4d4f7587"
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