class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "02b30adb483dbd1fb30ffa3f5d96e81c95dd103c22c1fe8b2e7cc4c98d525326"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e40ae638762c68da5d2158f516d293736e7b48f762abd75f13eed8ddba8fa3eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d74b64dd9a15ae96848c47e9df486ca2b4f19a952ac349bf136601486d54e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea4d01c958cb69ba44942121781a7ecaac947355458b3bf51e1b3f1328d7543c"
    sha256 cellar: :any_skip_relocation, sonoma:        "56138f739b112c5c54610ae5cb9fd95879e471c23a4aa6ccd74625308cee90b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7e832e49c9deeb0c3769a413817e7a97feba2bace0fae57a48329459b9cac98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f11afa63146347abb8c7b7f74236aa7257ddfc86b2cbf420eb71a650e1d41773"
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