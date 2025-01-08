class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.40.1.tar.gz"
  sha256 "c3f148eed874af59edae151b4ac700fae4023b787091930e546378805f70502f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22e63e6339689258a5c83419428244bdd1d11922046a31b8933227b7d8c6d09e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b99794d549f9226c33369319d92df7b6dd90ed0a931bd48ad6ab5456c06e13d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ac9abc8733f582f69dffb80c3dbee144755b351b0162fb2bff38327bc5be08c"
    sha256 cellar: :any_skip_relocation, sonoma:        "77491348151c8aeff80fe06ee98a764ddb46b18d5f50da79e89a65eee09010f7"
    sha256 cellar: :any_skip_relocation, ventura:       "2ecb6d533162217c6f1decf48f42ca567f2141f7ce4d4b39c7d8597265227892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a875043a9b5981c757b753a15291ca9843c0ba06a4cfbd9f08a54936b6b375b5"
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