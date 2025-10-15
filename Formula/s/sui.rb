class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.58.2.tar.gz"
  sha256 "70608177d3d6938db36351618630e9c144f37fa1c62b1c18a3c19555e067d76e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cda127b37b4a2ee83a69812439d0f0a91262f35a2427caad89fcc806ee4f9d08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d1a74bd4efab07fad4369b8eadf6b0e5b01ff5f0907536703c413e2ce3e8ed4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bcca6d1a962275bf0c54c7db44ecae184a6a780f67c88c479683b7873d16717"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c5edb1ff810eac0a1f40de1ccd68de4596d12815ab60304ebce768808268b50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e086fe55f94a25d4af2f4e64978857e7dffe245ed63446508c4bba5b900fdfa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b28a4cd8ad7573ed0a7a1eb1bd4f42c6325d51e142fd9d5564303b9eb6aea9e"
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