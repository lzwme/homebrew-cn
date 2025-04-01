class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.46.0.tar.gz"
  sha256 "243c64b2616473ce295d0df0144c07d756386b3e5e8f9aa934d438b2fc2a09f4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abffde91fea4b310e13524665b29052c270d8126440404644b188d25ad7955dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6094bc15ed281617f26e4f55a93a8877d47bdde89cb1190ead467876e4a1aac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84f023fabc4b03666d556574640cd5f1a5b06c701f5c67e5413ebf28ed42f42e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f34d074372ea07312bd7ba2b4bab467673c4fb5dac0cef8de70529490fd6330a"
    sha256 cellar: :any_skip_relocation, ventura:       "36f0ddf36f2bffef2582c7f580698191ad1c574c85e72e3c500a83f8133ce6cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2efdfb722ff5ff5de7372f46c1ef3834f5ea12205e2d3f7732fad8ba43f853cc"
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