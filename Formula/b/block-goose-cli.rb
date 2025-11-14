class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "c6c3f2961c137649fd5ae41e2f35360953840ce46ffd3fad08f52f27c363aa40"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21c16409e67b934766e37dbe69f13496fcb9d386517c358ed2909f8642fe2039"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e8ce8753e5bbc51f44e0a3e904139a4e6affb8f3a8de9f82b33066dc2a29e32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "413fd10d9e95fd866bba39960e3da21443da0eb239b54d8ff7b82ddcb5cab56f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a48bb71a00f05e1d383b7f136906b0db305dc6edee0d8e9036ff20cb230d24ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9227c02bc2f9e5b7a4d42526090449e3e6da9801ece0b7f3323e94fb8e1a0feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dac6c7bb6919209257fd250196e9885a1d0e6da65a7b2e8cf7f8754b8c882ac8"
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