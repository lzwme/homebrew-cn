class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.52.2.tar.gz"
  sha256 "4740d8cdf15b5dac7a4e5f3f6c20a823957526c6a63cf2b6c5cb4fdecd219f54"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "466f60e66e3652c9eb856674dd87afdbefdcf61aa12c509d2304ef8527e0509b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6828ec23fb9cf49d73caab9511879135b9320d4cd7202ed512fcff7034a56ec0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c31757bd3a2f6de79e0aee2615be61476f2e8c2a75f1c557a9eb7941c29fb0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab32efb2738107b2b837c59f58b1c407c5242a045f13391ee8073aa476280737"
    sha256 cellar: :any_skip_relocation, ventura:       "ed2842e5ee21042efd4c1f8b411a0d5ce3ec71e1f62d8206923946104db0156a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79b078d197a7f76c4ee6a6cb49212e0e1ceba72e6c034bde1b2b817baf3afd60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8982e08850f6bd537c7dd3c1839d5fb6de1740b367c3b144ebb1f8cdac0800d2"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
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