class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.45.0.tar.gz"
  sha256 "f26e0ce125e867988002cec8377b6bc0a6be7e480d98b3bcfae225562e0694e7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b61ced46f16dac9351e6f3b0f38f09489c50a018db63dfe09c45afae5a3188ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d32e55dd188dc90f4a9c6269f64bc465c2abe7748fb48bec68118f7f90fe38b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d298c3c05dedb07549ab23a06eb9bff255de8688f644b8366e7b0066b267c679"
    sha256 cellar: :any_skip_relocation, sonoma:        "c65af4c10b3a251d6bcd109c9a603abec4d92d5d04b5fafbd18a4768827e1417"
    sha256 cellar: :any_skip_relocation, ventura:       "ee09044cf6b0e5dd5679860c9bf7e8953fd1089d155590c3acb9589e84961b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca614580dcac4a3ec28b3f84005f9607692d5fcde76d96c47bcbb69a6fc53aa7"
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