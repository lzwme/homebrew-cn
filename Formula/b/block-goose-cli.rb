class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://ghfast.top/https://github.com/aaif-goose/goose/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "7ab566796ba276b987d655fdee0fbbf50e821a2c1314fcca66ef91b128983e8b"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10fb9b8dc73605d7a7e3f999b86482de4b211b658388be9d7768442818222797"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1810b6abea0f67f56d7fd8063c889c28e731332058b5ef3e4189e73f1fe42f63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b6de117ab645557bbcac2ff7b913a32859b8bc6eb4e274cb761a70b75c386b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d952fcce424efc8507581e8e550b194efc0451d4092d9d20cb075ec1c8b6890"
    sha256 cellar: :any,                 arm64_linux:   "e800c6c42f0042a3569c05499e35ba5c4ce04e721e6204f91a068f73ae513266"
    sha256 cellar: :any,                 x86_64_linux:  "b19a6fb4c353008c5a8fb2befbc0b40d18b3139068480b99730930ca8d4e5298"
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