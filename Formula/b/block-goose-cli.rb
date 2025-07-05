class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.0.32.tar.gz"
  sha256 "acb1509d3c1acff74fd1692a6ae59ee65e3af1b402dc1a50a2ccc71f79162320"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0854e81a97bd52b4f3f86f8dccbe34d37946a420d29cf335e5e24dd07652ffde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cbbdb98d1990863e13d4e0517dba02b885f3bee980beff628025aa790abf3f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "779a5a367d989771b6dd979ae5d47d5a42a164106f35ac2faf2b7815423c6710"
    sha256 cellar: :any_skip_relocation, sonoma:        "66a20d04fb86f32a78f684da05edded7629ee553c005252d6d3e254a8e1b45fc"
    sha256 cellar: :any_skip_relocation, ventura:       "8f5d21c217eb18be7525e78406602ecb1e01bb35b1b3af187d17972c5cdf8901"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e11b1931e7ce66bd1cecb14c4beceaf2f6cd369542afd16e1da5db9a7e96dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0ea8c108ddf7144dfa840b31b571e26bec392cdb10a695309f59da5959f3887"
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