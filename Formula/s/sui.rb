class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.72.2.tar.gz"
  sha256 "6ba70255392f36f3a9ff27b2a22bb60225298b69f3043f2b29e685b3631957cf"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "871189224e34faa6542cdd57803e3ad973d1ab1e8785c43060fcb4a271008195"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d9204500f57168c9d2e3927b5b6ea577594b76fb9f1a76c690f23ce4dc7541b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ec460e3e420a5c85b88e27d6048ecaeb8a27baad4d8164cfa3d427a810c3e72"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f84bc425999cc8120f792371928810da86ff3e976fa527019ba7116f0dbb8d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65849f6452549613a5d83902920244422a70a24c9af9d7d6704fa8e650762188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e432b6d76b86757870daba21a844196f1878537aab4610019b7b086fa9c30a02"
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