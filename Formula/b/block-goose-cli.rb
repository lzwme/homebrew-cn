class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "40a14d3799380d01b938883f8158d7a2121e8ccb4466e5ac531e98c827d1e325"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef4d1df73d0ffbfba7465615016c28b75c050bb41e92c1b8e348c70cdf6740fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58f028c2994c0e64279cef21acde26b023799f0a098bb5d06423f50591cbc1ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a65b5da17e58666f04dc5308beb81bb6e60229b789423bebc1d9a9273d464f52"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f84f90719f02f53237a00a98c6c6218ed8d486a6c14c45e563e5b5bbc581d2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af728baaf465504a81632726c10dc22ec30b8f5260c99918bc683ac4e6af822c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d011a5b89900a14f7fee58edf427b1b242c73efc024d67a5f540b4228846319f"
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