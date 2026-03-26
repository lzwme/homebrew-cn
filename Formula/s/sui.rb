class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.68.1.tar.gz"
  sha256 "768efe9c7d3a0714002509d34ca25e0aaded65478f329ef7561fbc691d9b90c0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "554f47f0190a7efea06128d39a841629661c2ad9a94c9efb12849c713212064f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f2f900da9bccc759f83a0a968fc9b944ef91f810bc33c29661dc978f681d5ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f5c2f188d90446d1d45fa7d253b93de38408b3ce702b7ec024ff271674d38f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a76bbd24e44d12ba33d1535afa3fec0f5efeea340cf7930435c0823e49a15df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80666c29e1607cf38c8f656e781c85661f98cb1f340bc8cb91c4e45b8da27af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbbad94b15c23a73fcf5eaf812ad5fa291ae023d1b4168729843b0e6a8145119"
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