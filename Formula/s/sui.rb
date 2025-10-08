class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.58.1.tar.gz"
  sha256 "a97edd3a9ab55271f95c8aeb9969229088eb6156dcb1a261d71d2effe824689e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22e0c89274d85e8ffe4d87347d39f2dd787ad9a521e3597aaf18e937fd66c344"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bb43c086df91930e8af8c054b6e278d0218eb77ead34e361428a1b6b8f98fa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "094c047a65a8a3edc4f9e9c03a291e2a6ccd4cccd1584ffb3f5974c3b3f79a46"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5d50c2f411d7eb82af38c38f43fa6c4223c549e74da23567e1a9106a6ddae73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea4d562f8f109ab9f4c0f4a5b103a30b65fe5dc4b6aa364752a4c9905312adb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a05028c32dc214901abeefe2e300b60c47e8e0f9c18cc3f5789754e06ac59cfd"
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