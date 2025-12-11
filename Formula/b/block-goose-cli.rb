class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "9ef1980f81b1241290ecc2b88f5c1a8d6df588e36537f42dd845294a544e6ba7"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b3a092dacd79d76c4c5eb8c42f3ea19448dd876a32b03756d004dd67ca9a0dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14b966635c760cd45107bda5e11770ba5cc31f65239b8c6539606ac3fb76b270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db083bb8a0a38f2c5fc31ead18b63ede4c1e0abdd1eb1fabb45982fcf6b6e2ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "407a801e16a1705d7cb8036645b45c27cfda1989cb0d4a54aebc4f6064c91af3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1ff6debfd34d7201a0a96551fd87161379081dc7731b016ad423a01ee538be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cceece16fc87f94614892556d317dbec10baac1aba8b998fbf42a333aa450a3"
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