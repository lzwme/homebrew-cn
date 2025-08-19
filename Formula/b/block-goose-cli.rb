class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "d792800ea69b720f44b6d2627ebb982a67eb4be4dd9a57bce4fe3f6afc6c0e38"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b2a8e4b1bba74be62ceadb33b4a85ecdeab395582b5395a02170110d7104ae0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d968640012060f0c7c9c5ff40b303184e797a61ab4d0225c4744e5b10614323"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2097a00e96ed435e79e2edfb8578e5baa7a4da1178aaadada3ec183e485b403"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1ea5f01cca4e452e6b4613b755613cd1e958ec881a6d10b178c529bdc7f008e"
    sha256 cellar: :any_skip_relocation, ventura:       "18ed02a884012bada3ff139cc08efd06b861757006ae37d7e9aa9fc0b03f7ef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1defcadfa3490d735752bc70bbdb712496cab1217cca520a47f22fd2809042ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0ffed2dc9d19e2ed040b2a981c915872fff82a9f4ee8c6b5ddcb8f7531adfd9"
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