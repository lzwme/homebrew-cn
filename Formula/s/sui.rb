class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.77.1.tar.gz"
  sha256 "9b76402cce2508beaef0b19fc46edeea2caff66136e57496d7753b640c8933e2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40fa30d2be63b2fdc0d8575bb09c6cf8875e9b1d9ab2072b3304b5ff261a842d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "987880791e2348e860524ed86f94cb7b9f863680165fe17974a52e834823dbc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fcba8a51bb5ac8380d2a76cb21228c064c4dbfaf38704631b30c94dbff6e984"
    sha256 cellar: :any_skip_relocation, sonoma:        "f04706bebd2ed97f2d70edadb668ca17f1b624284ad31a3e49351f5624f0e570"
    sha256 cellar: :any,                 arm64_linux:   "70936981fdba339dd7f3db8712d07d259c2d935de9bafe5d35fefe155507ed53"
    sha256 cellar: :any,                 x86_64_linux:  "6a694a146a85be314003e5467e8fccc07d062254bbaa748454a74175e04865e1"
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