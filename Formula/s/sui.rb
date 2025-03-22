class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.45.2.tar.gz"
  sha256 "32d39b2bef38c54f9ec03fce33938a510dc42555fe6b302a05e92497a20f591f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4e984c7f2a93af9c464afc0bc587a6b2b678d09600c63fed9548bb0991536f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74e5d626ae462b88517efd083a95fa873c544a7d5340239559a9507bd36b8557"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17e91671c070f8e7a6754345679b678cadaa8e40e932ee118aa4e1ba4142988e"
    sha256 cellar: :any_skip_relocation, sonoma:        "75a9bdbc07fdfdeac086f7e21172770d8c49e4852ed3f8ec68d9b3a68ac8c307"
    sha256 cellar: :any_skip_relocation, ventura:       "dbded4cb798598c020ee420b9057cbdfb693785d4a50aa5f811ddf0909b09118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f47891cb35ce08082cfb627f351c3e7c2df19b918c967ca73848dc62aa1b2ee7"
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