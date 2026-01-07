class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "69cc6d12f2aec266fab40ce589925292fa534664a27a73d942dbd34c5e8c1e06"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b44b92e5739ee29280a25d6adadda4205e956db5ee2206426aede2b9936ef9ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f54566b88e4e85c9da36703da42f4f2e7f707c27cdd948dc13a0d6c8e52e2c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd4a4dab8bfb14c45224bf1f6d4384adaa57183620ebab92b21bbde8d093932a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7324982af9126c40ac62961d6c8db33692d27bcfc8c519079854d806aadd40bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c49466ebc5be4e0afe7a0f5abe358a8bcbf928fb29661a44e6ceb6a46a22f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9a0b479f184f6dfb59e81f3bde61bfd7e8a25e9f3ce70806326b0491ce9fa36"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end