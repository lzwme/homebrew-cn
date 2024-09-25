class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.34.0.tar.gz"
  sha256 "edb23b9fc6aba2b79560094d72896d022fb9cee58f065f166cf81818ede87128"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f2fa5f6f51b997f8cad035e40049ecf05235e247d27364ad38dba8ba50dbe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa88521b40a9bbf7616ddb9b4108b7e2ee7e2bd89b17393f835c72bc5432aef1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cb577f607fb3fa74322e49f09e7242db492884382f6a116ebe7b3d37a690997"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbc610013adb2883218b83bc1941b0978bea04d6909eea8bba52e4fedccfaf08"
    sha256 cellar: :any_skip_relocation, ventura:       "0ea7bae37249da5c87dd720a408a871a88a563da35d51dfeaf2d0433f5d4e004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea0118012d6e247edf3e4c738a86158e0e99d72885ec67fcbee118449120a99c"
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