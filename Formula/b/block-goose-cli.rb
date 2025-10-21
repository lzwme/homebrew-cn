class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "a6dc72b31d238e96ecff2fada5e5ac2068e2e51ce8094f5d7b8827497b819264"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4529d97058efc3596b7cf16cb8dfa6aa7b44b6ec139f9ab156c78ac5f58b96fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07c26c343d9af075deff955e0ccb6786517888a67c028cc922a5b9fc36db0d9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d70dc8c62cd804fac5728e200a5054bb066af2984912b3a726a8e2572821cbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "01565c355c875e456c8c80e14fccb72d1753177b606f890c3ba9f091f27d674f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc0712545d14a02497fa76a8c3c8a31c0a7ccef08a817678742cf4a22cdf0d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd9ffcc7302b21c64e3cfe15603f34cbcf0c45faffbae9855635c441665819a3"
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