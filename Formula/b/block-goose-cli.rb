class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.21.2.tar.gz"
  sha256 "e52105b0c4c24ba2c31175ee8fef562af62c7e82e8b3b94abf64566f8d448fe7"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae4910ece38859b81c54ac85035df9896a7e96772b0e1cf2f979e1984e9aea86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9587e3a43456ed02859bb7ef5cb833c935839853efd1f978a0abb2c7d7136e09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "defc9868b49664ff2b9b52bfbd537870d4fd05efe4e8eea4b39c0a8918d62b74"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fad8ca56fa1c1f3a7d33ca478fc6c7da2726f5b8d8b0ed67908e0c495dcd1b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaa656ea1679b18da8ca517e6aad4643df29400ed545623d544bd3c27fd28db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdda0ba612b51a8fb8b301261201319eae4fac55eb72ab26ec62eca7799ed784"
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