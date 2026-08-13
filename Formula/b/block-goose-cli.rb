class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://ghfast.top/https://github.com/aaif-goose/goose/archive/refs/tags/v1.46.0.tar.gz"
  sha256 "995d4d0142f548e8adc9cb929b7d6c9ac8518608da0d066d5fc26d80e08a92c7"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08cff6c6001be1348ad128a6a2c4c6193c1f1aa1c0cb41ee0fd5a22a2ceac90d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e59748e167c7a83d436de8322847fd267a2ca63e99d8980fb9ef09f6517b0fbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14758d7f30ea39811fcc337de2ac58250cbec78b62faa8e9c6783e04d464f85a"
    sha256 cellar: :any_skip_relocation, sonoma:        "69b7a3cb9c861dc7e57c5389d599ef06187819b0d38bb5029a9a5d8ffbffcd8d"
    sha256 cellar: :any,                 arm64_linux:   "477bddb8e1955881f35fec3136b0381c87cb934eb7c59c401e9dba4d87e2f111"
    sha256 cellar: :any,                 x86_64_linux:  "557a9f43017aaf4d7cda7529ebe4533415a84b900fb69670d776c2cffb11675b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")

    generate_completions_from_executable(bin/"goose", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end