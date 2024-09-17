class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.33.1.tar.gz"
  sha256 "f2e3264ca9f09405b91f1c2720a94ea061fecaadfc7907891a96d277044767dd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e93b09d22158da87f9f02a32dea944be43fa3a620d77bdcdf069971ae4edd369"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a57b226251bafc03ceaac58620e6f05bbe92ce040753e78d6a44f5a0474cd6be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9427dab8f0c6418f0ad6207848b41774acaa1fc9dc23c90520f485925140f24e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fde18753ae3add3485645441b523aee04ab839355c5dfd1676f9ceecc4534c3b"
    sha256 cellar: :any_skip_relocation, ventura:       "ad6f10e13ec7eb4e47815789f4d75ec4c065f8f6703e9e9d3524b5e65aa20169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1636aeb2ce1fc169344fbce3c197e8c14567ad9ed5b20577e192cfec8f261163"
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