class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.0.34.tar.gz"
  sha256 "d117c6f6d1f739a08b7012f2117dd7c2dc2450ea62687aa2a933aa41ee21bfa5"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfedcaf84b4fe934fc424daf941031eaa65e5885d60932e3aba07720254c94e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d439b6cbd2ea3f427883d27bbf94c547bb7fef3779fe5403653afc719000d10d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bd5060d5e65e746d98867fcd2ad94b4ccae16360ba16bd8754fd3af846ec178"
    sha256 cellar: :any_skip_relocation, sonoma:        "21df625bc907911884cae3f69020ce8bf9e742c3e43bb908e32afb11dbfe28b1"
    sha256 cellar: :any_skip_relocation, ventura:       "ad01f292631a2795937cc504a9e91cbf5f9a0a0ba7ea9e81d8a8af470a632a0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f21a798308daaeaf6fd1f92257300c8619b017fa2a9a6f7d888b9b3665b5ae60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11adab6ebfc6cf0de4d184fcfc7a76d6ca6c77421d6627f674c1361a81057fb8"
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