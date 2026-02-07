class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.65.1.tar.gz"
  sha256 "863791e27ba32435c15d1be0aad96655139df5d6797c894bc7e74eb4168b0e7e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5af7ed7c65b4e91b4d45820d659c97dc0559699a45cffbd0afab5dcb22be238b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bc4c79258d232290be9488fec9de1818d807ab50379d3f29651a8768a225206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2cb9060c9f45777b0b294ef44a0fda22eea096a0e2aeda5767c010ef043f102"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eb24ce911afdda02e74d5ee91ab7ea8b5fb5e2751fa31af2686dcd2aa8473ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5ad527b5e324f3bc213c317452caff4d05d0c9f9412b76505c067bd58174c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "406b7d996df4061ef2c70de1e3c0ca7acb37afc2ca7f7846c950c83ccacf7184"
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