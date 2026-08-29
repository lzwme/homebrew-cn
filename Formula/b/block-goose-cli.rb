class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://ghfast.top/https://github.com/aaif-goose/goose/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "7b5d8713fc28e0b4760c9790e95dbacb7351706ec74f68667ec5f78ce6ddc38c"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bdbc0161c4dad6d54e29ab4f25e97985d5cd1fdcf8e8214eb426a05c4a1627a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d963cc7f3b916701fb651151f2c472377e8d5a8b73e5751a8238010e8c8b59d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41c8d3b5b530eaac998a62c406a77a1164a5c3cbfa39d18247f10de2cc93843e"
    sha256 cellar: :any,                 arm64_linux:   "6f44b9dbe9a380323887f79a3c7e32b2ad79e38ea311fa23a2ddd3a4c8556e7f"
    sha256 cellar: :any,                 x86_64_linux:  "6df61d6d6c2508b07d6319b24647efa6cbddd4988d08b4b5daa3fc110c54f322"
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