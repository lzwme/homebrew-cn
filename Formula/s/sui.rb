class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.38.1.tar.gz"
  sha256 "3ab3039e66b571a7217408fb5f2e58a1c3c92782e061cd5423147b080ce2d663"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64e40f933f095f75dff07f04a52d2133fb89ae3258db4caff72a29295903c82d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e862284d86cb73b22edc2015ec9e84a3d737fa40d8565fc5f1303598cf94b2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7d391182a069c5391606d2629a9f4eea68afe4f4b49f9d4f87ab14f27a5311b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c849087f5867b3a9fb08943658ac248a90c1c34a0454c2af5be8b92897e5e987"
    sha256 cellar: :any_skip_relocation, ventura:       "da784058c059174da764d1189202d8e21c0c4ff80f4a21e5231e1ec34b21a8e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd2f93ee504e4998ca7a330943d9751d826d8b588d604dd751f34f5cad8a144d"
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