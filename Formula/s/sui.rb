class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.63.1.tar.gz"
  sha256 "e59018a125864e2970c1b5a1d8d3c97819d6d7455cb5e2c086e683fb3444fbe2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae208a7b1821eebeec380fa197b75edfa3d4b46d6aca94172a7f76a6a05eb011"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a64edaddf3d37c74406141955cd7e41e2282fe9a05000328fecbd505670e41f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aef3ad2279f8fd5396880a8cd741521249354857981814f136e05e13fb55c61"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac9a5ac8d836b5b8f02e45fe77bb2581485c859976fffa31aef9e11a0920a5da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dffe24d86557af102ee11c969772658ded959afc73aa5f1a4938fe71add4f30a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee83ecb6df1ccb009d1054ab41c82ab289dd60c8c352cb705b08ed6c0bbb5591"
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