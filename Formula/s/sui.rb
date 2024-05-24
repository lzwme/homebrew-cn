class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.25.1.tar.gz"
  sha256 "4eafdaf3a5dd135e76d8bf0ae559aea7806dd129efa2d744b0f19948d203b641"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30355cf23bcf96f987e72aa92edd32d95a990b4ecd5fb5a06eeda5a8507cf548"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63b598efc5afb478e6319ea481aec6d7fe7175f4194bba2888fbe45b20a8d9cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16c944b1f9b83c1713389c631e217347b875017a22bcddc3a0df3210f7f6aa42"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4c3092d5077788b149c91b761e69ca36c7f2c37949724f1419848fba11f10c0"
    sha256 cellar: :any_skip_relocation, ventura:        "cb954d0f1b97ad5ab7d0e1c6a25feaa61e7eb947761394a713d20a2041014b6c"
    sha256 cellar: :any_skip_relocation, monterey:       "b12ebbf6a87aafb0279ed5145de5a4918489b6a6a6ba0f2b1c0f1e814773c331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd015e59d763cca083ecfe50f670a6c580e6ceeb965651d8bd08c0ae1d818055"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
    system "cargo", "install", *std_cargo_args(path: "cratessui")
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