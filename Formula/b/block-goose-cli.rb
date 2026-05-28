class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "b0d0f6b5c539d988f0015943b4485b48c61b141f5cb2c8975029e261b9dd2ba3"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39a4013d9ff90026fbce603245e05cf60f5f5cea1bd483e27b46a47270bd49e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e6e4118f43d6fa954b9fbc3f20088a9f59ae29e0d4cd8e18359380fb4a5549a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be3b14ec29bd9e904c4622afd0d9ca17394325c3c0f5867f88cdb59bc027faf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2018ab2ef33bf270e39db84a4d446e312074fa59965f82a03d560973c3f6c4c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04845a3eef7c646306e749b036d00289531ba83321baa2bccac4dcc13529432c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94f562016ac849d18433af2332532fc237f213318c3743d5fedf21278224b464"
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