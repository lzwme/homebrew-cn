class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.40.3.tar.gz"
  sha256 "9c66a1783ee09803a29a8b8d1f6cc16d6323cc6e5769a8ff7d7edaf1e915f57f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a891cad5f0e165809c5c8862349b00a8d1c3978bdb0e9e4f8021e6e55ad17680"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc932e06dfa1293b0dce8646d81a49061d2868e8a02a7a429b2b29e6feb96795"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9689fc09f44112e787690bc53fc6eacc7f16008f9c6c194936face0966a5f32b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b3a46052c5d710718159f8b346f16ae4ee9d46a4b5686868e2fd412523236fb"
    sha256 cellar: :any_skip_relocation, ventura:       "3917850596e371902a54d72f81f21daa5fb1fcf9555b844e06248971a91a8821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bf7cfb65f55ce868801fc2d3068d1050924ca81f4643e086d8e3deaed38d8eb"
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