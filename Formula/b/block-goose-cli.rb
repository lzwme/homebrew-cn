class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "e704ce35d70f40b7e1e51dc791128484dd63a3a210263c05ff666d7830522c52"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fea0286996c4eb924e487a3901bd812f84f53c0d14a0f403749b6a3d8d04e1af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "561d9d296c451ad6e0e78e2da499053cf4e59e99817fb30fefc882c79988ac61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f75fd827b5997c1253bf84100daac04f650b46b9306c07b2b5608213461937a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3880301b1c988674314202789e4680b9b84b72a43812698b200b04e3ffeee4f2"
    sha256 cellar: :any_skip_relocation, ventura:       "f38ba911c04b266af5b59fe291f6dec7bca4c40e9922cdb459069d7bd9b460ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7f7822217286c409f1dc6b5d3bdf9fe032489ba40dc8f8a4e773171607a0768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "467ba519d98785bca89bdbc42c743fb9147d94ce43dec8cac5ac1161b8e5f682"
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