class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://ghfast.top/https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.79.0.tar.gz"
  sha256 "5e193cda4f10121d192e6c3470f0c870670324df83ecf02818e1ba3f17855629"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd55881bcb1d16cdc12eac62f8247ebfde02031fd98cb98716120170ce7c7f0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c0843284b025b6fa14140a2cdcdd1d37c618dbcf24fb745208a28e6a4e0a207"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b07bc2056fa602fa5a55b9ccccb0ac85899dc6f3b430f22b91372c643db4c62"
    sha256 cellar: :any,                 arm64_linux:   "de521a970d861221f2ffd779aaf2987351756701852eb86d83637dded53a0052"
    sha256 cellar: :any,                 x86_64_linux:  "5de92fad40e8d76e467005a7018685b39df4dddded358a24b69a5b82c59abaee"
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