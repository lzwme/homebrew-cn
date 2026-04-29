class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.71.0.tar.gz"
  sha256 "4915566a21d2eabe2b98bbc63f61271ea2ca825962532186bd6d7b2d30948c3a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71bd43d5308616ccf85572038ceca97be5d159882d1bafc58822b624a0c7707e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbee4ab7ca9013b2d3b6795c06c9ef168079a7af4033cfe0aaef79854d69c0db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2385e72fa3190a398bcb28ba8a5faceba9d400a619e29025c903a980f2025162"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8c49bca957b7597b68bc0ecbc1927c2a2147948047eceac3c435a5378618e56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "298dc61021c152308ca223900282f7469779db116a69847cf6d4f1692ed57310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8010f6a0a148812029a80f554a4a970f44324431e29c922a0eb1188a8af7f1d0"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
    system "cargo", "install", *std_cargo_args(path: "crates/sui", features: "tracing")
    generate_completions_from_executable(bin/"sui", "completion", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sui --version")

    ENV["SUI_CONFIG_DIR"] = testpath

    (testpath/"testing.keystore").write <<~JSON
      [
        "AOLe60VN7M+X7H3ZVEdfNt8Zzsj1mDJ7FlAhPFWSen41"
      ]
    JSON
    (testpath/"client.yaml").write <<~YAML
      ---
      keystore:
        File: "#{testpath}/testing.keystore"
      external_keys: ~
      envs: []
      active_env: ~
      active_address: ~
    YAML

    keystore_output = shell_output("#{bin}/sui keytool list")
    assert_match "0xd52f9cae5db1f8ab2cb0ac437cbcdda47900e92ee0a0c06906ffc84e26f999ce", keystore_output
  end
end