class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.37.1.tar.gz"
  sha256 "f35c0bd412bb9880b057112aa9a1c3dcd1e810ad92f935d166578a7590ff098d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57225d832d53e20fcc61bd0280b5ef00dff7696cfb60bf4c2afcc47dfa3b9b32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16e8f814afe2cfff96336765510916b3c2f47fd33ec31d9c5360250f2fc32b65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fbe115c74387980573788d5469cfc281f7e6638fdfbb48b2b5b7ef481a5776b"
    sha256 cellar: :any_skip_relocation, sonoma:        "df4776ca4b86ecb3b50cac41ec4322010e2d9de50955abb801175bbc6f59f457"
    sha256 cellar: :any_skip_relocation, ventura:       "15661ac7b01011c267fbec07468a850ece2657abe212a7b493b35a3bad51bc95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dd389ebc9cbea91f215b96d0893427fe2cc52e79ae29293b724905e85b57361"
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