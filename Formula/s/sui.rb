class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.34.1.tar.gz"
  sha256 "c7245b5078c3e4e3d12e58e43bf5de69bd49a7ebb3df73558c26e643a9200b6d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39d067066c2b66ab7afef40e9495f8ac9455ee337e355046aee03933bc3f317c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd4e4e68377fe6fcdbef42f1ee10b62644fcae4f22eea13fb883281040d8733b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36a106a09ff3a374ecfd88eabdd8f7e199afac47dee4d29d47cd31d0c27e13dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8bf560a375771adf37b9c55186f64a6be1ce0993755c631e4d8b35fd2901888"
    sha256 cellar: :any_skip_relocation, ventura:       "25a388dce96bf5758e542ddac30c80759a077973b464535f38d82728e2f2ef78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c17856a30b9b2d9cfdab5bc5bda4df31549d5bfc03398926d0b7bdfb8b11b85b"
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