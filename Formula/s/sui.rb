class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.56.1.tar.gz"
  sha256 "f599f5c27d6aac87f0972bb4e8deaf0017e4908c1ad594fa7913e686c1d1deec"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8997a16c7ed35d900b243350e50b76b058cab9059de0f8d91acea56e98384137"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9094f71379d0b70118a68a8c6ef066694f64f0925860eb1277ca4467b3f6dc4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0efc73d2c7e6a76ffaa59797db896ebfee90964c1dddce9c1df094ab7376fa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f13120aae35bf8e4946d29e84350745418ece6fcb7ff0bd77e511cb0bf4131c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c69e865149b99d36505c88270a6e125b10706752625dbac343fc041fc22f7e5"
    sha256 cellar: :any_skip_relocation, ventura:       "891c2d2a9085d93befb529955d5c94ccbd5173022f0b4c3a685e6ad20cc0fb5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "438a7f75d65e42499c735ca272bd6a4dabe192777616bf25f8672779701a8d4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "512e642912e06eefc12d892bcfd9e8f10d8a07e02dcc172ac1dd41628701bee1"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  # patch blst to fix x86 macos build, upstream pr ref, https://github.com/MystenLabs/sui/pull/20921
  patch do
    url "https://github.com/MystenLabs/sui/commit/85fe7ddbe01067637d2e771360d26675dd5fd2aa.patch?full_index=1"
    sha256 "ea19ec19ff5cb969f218363618a23afa1d3b36e8ddb04670a5fcbaa886321559"
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