class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.77.2.tar.gz"
  sha256 "63ffe745b1efe9f4abac124d7813af133747af71d9581cbedbaffbcf63b5082c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "546aa18c579537f30f6589b2b3b33b6a579867d6b318080130261c6a40ee3569"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ed393df812f4752aca31fc30f1eac41266e816ce0c684cddc976af086d174d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af9c4f7529f22c8d6e05f986a430e9a720d924bec5c839f55719935e25eba97a"
    sha256 cellar: :any_skip_relocation, sonoma:        "644ef9ad7e36ebd120d9a4145dcc5cdf5765c336c7f794b28b03fbddd3109816"
    sha256 cellar: :any,                 arm64_linux:   "815ea56845cd4b0e90668f2a917e72fdfc7b982304427d9694a090d8131bee5b"
    sha256 cellar: :any,                 x86_64_linux:  "85c62e92f2998553c15230e5638c6bb70afc281d7d478215fac9e1bd7cb6f2c1"
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