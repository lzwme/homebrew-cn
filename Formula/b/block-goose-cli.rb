class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "7cf96674cd5cec5791b214705239dfe5687ed1cffb03f22488ccbd04951cb56f"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f8a6338bec3854e3f58a361d8f2bd1f539b9f811ba73c9e4c7cf24d1cd6d177"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aad6023db90a99b5fbcc8a37968ea4dc560cd7b4ac250bba3e8df0dd9a88c9a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "443d23967f15d5d3165ae33b41fba66d7bd14149be4acc2116f22706017fd008"
    sha256 cellar: :any_skip_relocation, sonoma:        "d80232413622e79085cbeec094da2ae5529f4da10ed7ea1f0098e0b4a32b059f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1ecd1f8155f2d21dbba6700c63970e62f0edfb837811ba56a52543536867c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9bb3f2b4add1d20045a89e435e1e617cb95bfe229c8fe3ef4d299543e1f28ce"
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
    assert_match "goose Locations", shell_output("#{bin}/goose info")
  end
end