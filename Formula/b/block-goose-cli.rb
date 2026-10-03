class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://ghfast.top/https://github.com/aaif-goose/goose/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "85cc5e76a12e364032df4bec0ed0738a910c3e12ec12731b4405d1fdb18d96ae"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6474aecd525c0df5bbd8cb7dc42f0056d28c6b1a31132cfbaf0cefc9c48afe6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2be17e3b157bebc22f9b2af96cf2252a1c3e686692e25edcc7799302b66d0cb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89ca37fccce8c984bb1e927dcca4290ff7f9075f8073db0a7cf095966fe3bb72"
    sha256 cellar: :any,                 arm64_linux:       "89d63ab9a5056390195b2fc1c26696ea2f3d21f2fce91837586af9cb1f2bc76c"
    sha256 cellar: :any,                 x86_64_linux:      "474d8f237369a6488a83705bfd2a0be87bdcf7bd9dffd9eff018c93f0e2487e2"
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