class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.44.1.tar.gz"
  sha256 "df3fbf78ee7320b2a9db71e56187bf4cbcee18ce7bad4de65e772e39ce27597e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f70a7c9cd09170a49bb72804e211940e517f79eccc06f22ac8f67c1b5db3b60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66871e6172ed5308ab33ca805a20e8df41f31c19399194abbe05e42235a5ce96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2cb7e5bef1e917374d871285d7e755d5d3898b335a40e926b5f17360472e866"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0671a4d4deff92c491dd948fb1e858126554039a87678ada03e2b3efdc410b2"
    sha256 cellar: :any_skip_relocation, ventura:       "f70093b99b0d321ba4d02520156aee97a87e8a9a27347e290e25acded0e42694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b6f14799c9ea0679bcff7403b34d02905ffed7669512dfdb41c5a4396458ff5"
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