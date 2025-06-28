class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https:block.github.iogoose"
  url "https:github.comblockgoosearchiverefstagsv1.0.30.tar.gz"
  sha256 "512de33261c3f58894e4f4ab997693d21aca2d484929590b0a8e087f08b7883d"
  license "Apache-2.0"
  head "https:github.comblockgoose.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a175ba1b05ef14b7d8ad249d53230926c4d1bb3f23ffb6121f1f4ce341be5e39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "696ad117be823403a8a13e10c38ef9eee67940cfa54bef38091843b824ec698a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf2d64d997f3e9f6d51fa8c14183fa78f6cd82ebb0de200955430e3972c17627"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc3ee2dc0913a609f0ca314ec45aacc1e2ad5030d2221c46522d95d28a67f1c2"
    sha256 cellar: :any_skip_relocation, ventura:       "0c6cf547d95a1b8ef7cd846d568b83d89c256a0e4eb6721722e3ecc81fcfa36d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "079fd103b85c98a48612cdb08dc519721fd90d0dec9c2a85b69e17b52f4b1ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1fed19c605dfa112d49f50324d0b93ca70ee7dfaca07e9c283631d3b54bef6f"
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
    system "cargo", "install", *std_cargo_args(path: "cratesgoose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}goose --version")
    assert_match "Goose Locations", shell_output("#{bin}goose info")
  end
end