class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.60.0.tar.gz"
  sha256 "04425949725598f57675f6cabea5b05d548e67f21bfa4faacecfae9cb4a35583"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ad69b966b7e679e92fc7d2207d5fb75673250c967b89abeea7355e6dd9cb4c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2f6a4db1e9f3b61bf89c831f63ac49aff8a5e9e53efeb928a7863a3f96df3e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0b6c4378b437adffe7b991a64bcd32c1f1b97122bbbb1095abe2dff66142275"
    sha256 cellar: :any_skip_relocation, sonoma:        "646c7891e09380e2e87c7ae44cfc9f98570f8931bc446f7689ada15fe5844945"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9453800dddfe80cb7aec2ba45a188202f85c53c05be02bfff826fb39b9c294b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73a1b293e9404e8b4ec0d43f068de6f3758c5da9e6d39a81a33746b8d5abfff2"
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