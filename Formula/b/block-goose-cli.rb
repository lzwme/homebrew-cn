class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "85fbaae68a7ff6d9e3c7f79c1ace1bb22a42b3e49ad5c6403dcf95e96cde4a22"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "362a92cefd1e90d1a57236a9db2db982db4a9b2bf256bb851273dcb6e8bc68d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36fc1bea0812cb930d579cc46782bcd75b40c064fccb2c12f50b3c5a27c63a5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "333b26c873471b17603095812b36a87469d44c0a50338c9daff0b67b3b57fc71"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6327f273aa886d3c72e000bac4377daa639093a2a5407e655aeefaeb09397ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a585702f2b231fee68ff73b9b001e293525dbd0e2fdcb6f9ea10d98c928e7b75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1feaa3478c53eefb4505e67d40303ef8f05270462930485b27a63296c5d96d57"
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