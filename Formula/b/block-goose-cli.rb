class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "e43c6bc980ee2d8666c1e7f903f48ae99f31e365838e1a4ebfbf1a3ee5d6df48"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66b6ac41af087f84e56240f2f44b2c4ef4b4a71bb64808dd6a0c7d8bdb06d58b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26f77fa5ce3d094f550761aa69fe2309b6cbc8cbe5db3e355dee600042609bc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b019ea4609eb33c9a33b9dd704fbbf5aa0b108dc49b793e7c5970e9757d0328"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb4cd2afa163f5d1612320bb8d669e8e4e6b1461cfd8f8c303133abb729bec2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3846888690229b25b80c80ff94d8325965e8daa09aa24d845773945b57206654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac4564e7771888a9ec232b4599bd43cb68b75999bd09b53890b71029f9f2f0c9"
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