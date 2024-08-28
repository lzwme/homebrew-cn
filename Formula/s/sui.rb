class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.32.0.tar.gz"
  sha256 "796e16f4ab2e32b13beee78029add82171b61772cf2ffbbd0f36cf499261a791"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "460a3698d89d00073099053b4d9e7490f77d02d4d495f4c3f5f6532590cb447f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14f959a8278103db8fbc1737df92ad0f3bdc782130ec88f694d09554dd9c6584"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69b23d21ed8a16c367368068141f5166f05438795df4da1d96dc22ad48af6e02"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed7f33bda31e60935ff04040ccc2429a5c1371868f535adbd34976ef87468627"
    sha256 cellar: :any_skip_relocation, ventura:        "42099bf6dccef47180b98bcec39362b8bc8c1e712faab956ebc698d761791106"
    sha256 cellar: :any_skip_relocation, monterey:       "a62df83e8ce3d00febc32a9162354c535979eaf8c2e525be1b5b646d348ddd47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ce478e3de8b207aed92eba27ef41f8b60d41456f3ab7564f021264a050ecbc4"
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