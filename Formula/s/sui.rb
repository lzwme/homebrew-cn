class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.54.1.tar.gz"
  sha256 "61f5e167169555a51fb55083868c9abe7b76aa883fe76e3a1d1b6ab7c7e9bb6d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0676265cc09c757127722f69fd371b5bb03bfeb5cdd7a1ec776f8a42673e0a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f719da01d46c57fc0c4fa7c6f0fb432e0ac947df1adeb55119302d0337a2b4b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c75c1e82dd70e8c0c7c5e05735914432ee4ef3d983710fa04773946d900cfbc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a1a0758c2ad24caa2086dac1f4096137fcdc3c383ca11554c651dd1fb1af3f3"
    sha256 cellar: :any_skip_relocation, ventura:       "257c483871559592e2de82556ba8a90391acf86043bd766b3436f65c04558767"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "561ec8bb1135fc37d6a3aadc95bb428a60efc32e19322c15b1e2b55590a86cd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b12180d894e3a2be6ded62e23bc87c118b540b1eb42f51ad12647bc8485af160"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  # patch blst to fix x86 macos build, upstream pr ref, https://github.com/MystenLabs/sui/pull/20921
  patch do
    url "https://github.com/MystenLabs/sui/commit/85fe7ddbe01067637d2e771360d26675dd5fd2aa.patch?full_index=1"
    sha256 "ea19ec19ff5cb969f218363618a23afa1d3b36e8ddb04670a5fcbaa886321559"
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
    system "cargo", "install", "--features", "tracing", *std_cargo_args(path: "crates/sui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sui --version")

    (testpath/"testing.keystore").write <<~EOS
      [
        "AOLe60VN7M+X7H3ZVEdfNt8Zzsj1mDJ7FlAhPFWSen41"
      ]
    EOS
    keystore_output = shell_output("#{bin}/sui keytool --keystore-path testing.keystore list")
    assert_match "0xd52f9cae5db1f8ab2cb0ac437cbcdda47900e92ee0a0c06906ffc84e26f999ce", keystore_output
  end
end