class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "3778400762dd8f1a09355cb84f151c7acd3a329f5c7c2fe1be0277862f9d20a3"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d18d09118a78d1bcbebf862f87087d9c2b3678fdaaf2d8bd5c4e533c93715f0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b492828afa30c69eb90d05d165914cc0e9aab21d215208a62cb251ddd75f48fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "210e13b0c17df3b6470b33fe306d4c51cadab40e550ce3248c71ed25153790cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b71e613b89d6c893a87e6db1055783363f968daa8d6c7a3513cec559ad25d4f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80fa6e3e7436e71950c554c22b573f63a490270643d80a62f69b7c0a2a8f8f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f4cf34e9dc8246f7ae8e4b73034842f7b34fd9972cc5236ceae138222e5c531"
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