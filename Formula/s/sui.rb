class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.28.3.tar.gz"
  sha256 "be506b0f4d65c0b74d038d57965b595dd2a519fec7cf695049229ad80e8ccf6d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c33df789d0c5522dba65af0f2305a3b258449dc48a0caa59a8add0b269a0a77e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b8ef55aef227cecee5f1476afc87f0b40590d1c193b1d12a9a08a175fe85dc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faae30f08a0514d585db7bde9de3562ec217e45acca746fdba934955875537f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb379e1d800969763f0fa16b3044945e765cab369fedb338ab3f1ccc6a1b951e"
    sha256 cellar: :any_skip_relocation, ventura:        "d4d2dec7aa54a1368cfbcdf4af3d3239c55a45b28ffebb18e896088b4a119e1d"
    sha256 cellar: :any_skip_relocation, monterey:       "377a9b88910d9da26f2c6e8a29c8563bf90765e460f7020cb1376db5b615e08a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c44d0afa5dd22765f768c6cf61aced702a2cf3e28d253280353dd129cd6b37f2"
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