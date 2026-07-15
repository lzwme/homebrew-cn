class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://ghfast.top/https://github.com/aaif-goose/goose/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "4f81792de25b0f04547bb1177cd64eaa2e094eb0373b27513558d0d36742b379"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcfd6d72da6260ff2ecc300e218a013147c9eb70201be7aaf8fe00842009f44e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4a7bfa37d293c034e3a64a41164a9ff727786b17d80e13e7ad876832c66a5c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e1c276013b0a9424c193725464550a694c6a465d99e6e97e3c0d877c31721a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "04eb01cfb7fd35d6854f0228cc6dd653c4a98ca51e809902a91ee4ce20ae49bf"
    sha256 cellar: :any,                 arm64_linux:   "d567cd581f7119a194893745a7e7ec8b6cf0016bea3126dc1d9d27070a74bac1"
    sha256 cellar: :any,                 x86_64_linux:  "76e42000a749d5681f35b2ff9f233a9bd593559282d8e65fce015dc588aa9774"
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