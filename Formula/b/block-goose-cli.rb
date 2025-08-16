class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b00f8029e22a06020891ea3d318e283e6e62f53d07aed17085802dc754cfc078"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95a59ddeef8061d0406f08809ea1df21e36b60903b2dc2225ab9b2409b3a921c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c36e1439195c69932bd5684bf95821f0cf51e01a575320125d1f1d558111c311"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8a9cd60230b5f991e5c6cf09bd078b8d0ce8725d48cf14ba1c6a759297b4ac1"
    sha256 cellar: :any_skip_relocation, sonoma:        "18c50a83ab2fb022ffec4a028da237da4d75760e5daf1b658f476da16725e38c"
    sha256 cellar: :any_skip_relocation, ventura:       "ee24573b8630301e02fc5131ad88af21369b9e1b8f26c7638875d08aa49343d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "143ab807b840f7cb6579432b4b161158e59a6cf3db6c2d0fb836bc880b1f741c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21ca72b35af1eb49edf7e167607cdf3dfa85fb1487fd97026a923d1d50ad80b4"
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
    assert_match "Goose Locations", shell_output("#{bin}/goose info")
  end
end