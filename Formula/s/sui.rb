class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.53.1.tar.gz"
  sha256 "d3c3677b72ea47d9f70390151d3f90d4a1e40c187996545bfafd44350d966fc3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a664430d4e644c58b44b8b1bb8f9e3cef131b2b2e2c409218c09abfad2f112cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86173ec78023ec1ae239b3067da7947d67465d1ae2da68ea726e393857976a2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b8be0e88025e046a5cc5a143dd3b9befd0264e33f5cfdfc5bb7a37ecaae7ae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0a4b2eed8fbdd76021c66b3cb4bdd68469542f818b8cac5b8222cd616e9e577"
    sha256 cellar: :any_skip_relocation, ventura:       "2caab506ca6642c58969f644387563cfb4f95962aa1f1ebc35885a4405ac2ae5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "070816ab136eb5c50828239cbda8743cc3e22c9d0097a117beb0fea86e152115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d132af1332607a58af13d81271c8209201b4b7d37f906fd4d5e55e6176efb20"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
    system "cargo", "install", "--features", "tracing", *std_cargo_args(path: "crates/sui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sui --version")

    (testpath/"testing.keystore").write <<~EOS
      [
        "AOLe60VN7M+X7H3ZVEdfNt8Zzsj1mDJ7FlAhPFWSen41"
      ]
    EOS
    keystore_output = shell_output("#{bin}/sui keytool --keystore-path testing.keystore list")
    assert_match "0xd52f9cae5db1f8ab2cb0ac437cbcdda47900e92ee0a0c06906ffc84e26f999ce", keystore_output
  end
end