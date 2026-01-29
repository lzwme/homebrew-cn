class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.64.1.tar.gz"
  sha256 "c395282ecab34aae82f7f873a4647af6e5ac6b8d4c1f331dd2d8f8dcefe8a582"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8a17264e2204bea67cd7cd41a611b509fcadd0be75df4463d5a9247bae8830d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bfde4e865662c255eb9f901dbcbca905585869fb526153c6d3bbfaa2d2b5100"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1527e342309a6a42ed9ddaaffed68afb38843aa58e1d9c703d40ebf6f5f24f90"
    sha256 cellar: :any_skip_relocation, sonoma:        "00fee5200c72055d7e8d03d94caf6672b5d5f092922fb202eca17871279619cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4fbb0fb1151a0fa54544edbc4c1619245562bf6a0d9eed405468035b707933b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c508ca634110900151d66b9db1e6380eeb74603594bd9ddfbddf5287b03c736f"
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