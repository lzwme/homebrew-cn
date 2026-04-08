class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "faf89a8309f725c928c82f94a9ccd017dbd0fc3bf79bd3533962ba97d056f762"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e306b3f971bba9e9b968a3595663f02231805c1d892e884784e9d9711502469a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81e9245dd091963a740514bc9cb9ba38a1e543318e9a18ab3172357007d71aff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3e3dca431eedad5a0bb682cf3d2ae8a37e9ca496b1115ffe623b73ba8a053c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4b2468a30d227b5411f722c70a6883b0d4bb202ce90e313f5d673d5fff60aea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32fa42c28fe214db02a46ef47f994ca9cde86fc4c83f984c0f42b02df9ff5254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee34ca6befd986acec1a6cddc6f6fd4b2943fefb0f133d1b0c4946e0ea884366"
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