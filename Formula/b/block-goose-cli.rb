class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "e6d3a2d45c828abea71c937f36f62ec731a8ac30e8fbbc3bd21a7e803f940bc0"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45b2c85f7326925fd463ffff6e276c8c90c39484125c2fc3c7e6e092de2e92cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97ce7c0978b71d06637c7ab89897561378cc39dc2ec206a8c00af1e0fac70be8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e85dd5ebc562f7e70a64ed75d1ef16b006840320e0f19912f22e13ec43f7a6b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3caafafbc3ae40ee3325738542e6ddd3ccf65fd1de3410086f0c1831109d8a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16f51d46b67796a5a6be8b0a70a461d4d48b895c549c5d70e4d9b7c7c68aafc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c334f4b73eb400b2ddcf49e9b31a5c4a15a939cb820f27f0928967589b609fc7"
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