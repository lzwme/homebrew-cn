class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https:block.github.iogoose"
  url "https:github.comblockgoosearchiverefstagsv1.0.23.tar.gz"
  sha256 "cc5d5d52a78ea794b5bb992786fb13fdd8dfe3e14e3747c952c095bcea1dec4e"
  license "Apache-2.0"
  head "https:github.comblockgoose.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93d1f69b039c28409c0e20a81ccf4a8d1a01383feff8dc5bfae45c4f323aa7f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b72a5b72b8f70a80894d7c5c36be297682daae44f973915bf21467d3ff69c07a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "161f5da57c3065262da9eb28ccfb13dd12dce1dbbcc7c25f5eb4cf97adf99d08"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e0cf2bdc311fc37aadc3df6053b35d344d15af10ce04b3e87cbb0b7217d4711"
    sha256 cellar: :any_skip_relocation, ventura:       "77af89ed5aeb3c6ba964b63b3f9e26617ba599a1f6fc89fd546e1f1a24b00360"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a233a3729a77223651d57e740676df2dc5c9ae6eea227bc0ea76892564e91da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c628c1a6b9682b35a226ebb0ec90daf825ae1ad208bbf1e2abebf12fbdf1e64"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesgoose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}goose --version")
    assert_match "Goose Locations", shell_output("#{bin}goose info")
  end
end