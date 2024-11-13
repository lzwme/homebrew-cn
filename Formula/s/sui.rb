class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.37.3.tar.gz"
  sha256 "0fcb7373d0b59ea17d7fd55903a284ae3bce632663bb3eb303c22d3cf759f48b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34a39f25cd4bc8606f5db0d7cca42bf21f91fc83b286b38154d26c89594062eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44f4edf554c795318d7e61c547e1f55562c1f4c51d27ba4422e21e0494371064"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9093ab0c734738625d6eb671a4878c7fb77316ac1212b0c997531f9bd83f8d10"
    sha256 cellar: :any_skip_relocation, sonoma:        "358921cb0ac8ebc76031768ce6a225503b2d63c1897a4194e02c2e03f86af6d2"
    sha256 cellar: :any_skip_relocation, ventura:       "1a5d144fbd3236e7d512ab0546d1938be4fab6fcafd01cbb4f53b94059612b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a62190b8481f3addea83f44544455758e9282846fd5a15fbdb9d5e6a29ebb2cc"
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