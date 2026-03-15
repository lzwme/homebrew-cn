class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://ghfast.top/https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.12.0.tar.gz"
  sha256 "a1408586c4c00270692bde14270046faee16e3d9ae0bb6600f78d76d083ae659"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f8d7e41e5b7d4d1dca0b4927728bef2b92434014f237bd403f8bbf416d1dc3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "137777f4bb43a55f072aeaff50f8688455f693ad5b2ce0f94b4d01a5bf56f812"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e19057e1cd151f545e00bdd84938be85b3606cc48c7cee3a318a4526a25a703f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d6859ded265cdaa4b2ea0f6cc1a3ef61b3f67ab65ddb703e3dca595749a7c4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf77573999a09dbadf3702806c90c78b97465bba13e39863680ac4dbef98334d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca7616df4f6a7549e2a6c741a91f9a2ff5e2dfb749a1f85cdaad1e38acecff17"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end