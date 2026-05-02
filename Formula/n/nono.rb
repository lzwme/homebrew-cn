class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "3fda60ecfdc10dacc35c8d2ccd17560c2b3687dd03b5ca5a3b2345e13e8f9cd8"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76296dbeb89783f43fe801688d8724fc065f6d264a54d9cb4e13e0e31f38ddf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09f110f742ad9b558f2a93cf288b2791861f3e04626ab90c7fcf4d3c66915003"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "497354d1dacef474ccf073f2af693bc88d2fd43f8164995a5f38764a4206436d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dae025e970416bd36dca7b8f587ac205ed8e620c75c61d9fc5d422716c0e88f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9850cf40158c251eff481f93a8a21d5d33b8cf6a1ad6503babc231248cda48c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8308374cb3a922c20f765b56b0a3c8e4f5da56b3a840ce026a262633078eecc5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end