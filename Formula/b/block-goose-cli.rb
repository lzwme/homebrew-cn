class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "1572e200b231441d8715c01bee0dbdb4e1ace1a612f15ccc758be08e571540c3"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71441b1092a80a7bf193dd1b0294a93a2a82ee9c911b42a44f64a809bb91a937"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e5c163eeb4c31a56c55e0fac0fa3af141cda9465a91a43eb86112c7df786c4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6118dc54e88922a20f8187e85d251f025e442a4d6843cc2f1b1c2aa3008adcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e4efe610838b717127f7c693d0f1aab6d17d31cb3a86e2b915712faff326345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c274c5ee3c735a18aaf84f01ccff386e2707016b402558d27a145022b4b8730e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aa154f012fd3678390146a2e8d45828ba11aec087ee609eb767fe4952133e5b"
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