class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https:sui.io"
  url "https:github.comMystenLabssuiarchiverefstagstestnet-v1.26.0.tar.gz"
  sha256 "7109c2df48a9f13dc01e5bf403bc25e51428f287165e4ccd901ebde8a46739ba"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^testnet[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82f6de9a5d754461bfa1c320c775365fccba95ff1fa3ff43a9e342c7ab771c10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5128a80bc47f11f227f06fc5ca3dc3ebe043856849fd325a8b6f4b1c4fb84fa3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c2277011d96d477ee2e1503c3776c469a4301faeada8d391bb3b1010a7f0dc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "506e1556cbf0fa0b21de9b98eaee346d132d74f88c883e39d16e22afc4bca828"
    sha256 cellar: :any_skip_relocation, ventura:        "7d0d0894bbe9ff03afea9695cb05a53d9cdf66f760c7bae3e520a79baa87eea0"
    sha256 cellar: :any_skip_relocation, monterey:       "884e3e3cb2eb0084c4d8054d6d46e4d6066707a015f00473ce09d78bca2a7480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a68e100359a64e93b42de54a296e23c246e4cd15be3ecbc21e1c7ee942a2e126"
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