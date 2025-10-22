class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.59.0.tar.gz"
  sha256 "4456462ff7ec00c703478bf2379f35eb83d7183294839524f2d76dca8b0ffe8a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "936d1b72b57ca5e5330b50d2e0bec91f5e226709290cf23addd5b92d16e416f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2f5d6f0880de3bec413737be7b0beddd8be8748d00e0c8fc1aec61b76d27717"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6229071f634dd4ee632b58e5bb98375802a3780b71626ecb83769ce589dbc3fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb920de8de4b31f9ae68a5949c80fa6c3f93c3ad323b2559d32615b74333bc92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63bfef6f0e1bf4b3bba589c3dfc4e8ba33b733c2fd9e0ec55e5deb970fbfa411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5134bea5380ca2ed46b8624b1a665fceb9901fbad566c51e8abd5dc1206093c4"
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