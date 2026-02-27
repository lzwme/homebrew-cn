class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.66.2.tar.gz"
  sha256 "2f571e1bd447c02de57ba0b8385c3f3a2378e428bfa2f5b4a2c33230454c0f09"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9434660852c17c0324a12581e9b71867a7314f8858e14c251472e27d86e07e42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e11dcb6fc4804d5608456d463a3ae359581bb68890b5165221a3baff9d08a8bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4402d2b96e6acf2c15eab32c1c592438b0373f0a49a5313c2971da3f9d83799"
    sha256 cellar: :any_skip_relocation, sonoma:        "64b15d45bb446ccc5ff11509f61934243d175188e7eced425802aee04929565d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afec8541695145c35602bcbd13ad4c939ddf7fdb0b9d925760ea4c7c1c9815b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea2d7ea252657d9277c335b878f5d95e2a0b9a9938147372bfc9194ca41612cb"
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