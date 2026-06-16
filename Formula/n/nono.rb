class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "0199ba14cedeab5d1cdab835ce074b655b635440c7eba8c1cf325c3f952964bc"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b109f205b8e65de9d788d50e04f4a95c404719b92ccbe046f36249807332d20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "456fbcd44f958e4a4d2266e77cb3550e79a994e9e74aae4119e4d5c0fa5002e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddfe29abf54e469f6d04d4a9e6123becdcb8271a637cde90441142d2d7296742"
    sha256 cellar: :any_skip_relocation, sonoma:        "93cbed3005de0e382a33dcfcb4cdd0c7010154a60dd03a8a7041b90e806f1618"
    sha256 cellar: :any,                 arm64_linux:   "865b76b5d880daddc1427c48130c060b02ecd31233d33dfa8100ab4880406352"
    sha256 cellar: :any,                 x86_64_linux:  "aabfd1bf5bb9b65207cd0de615eb674205f8c2268ebf9ccda3ceed5931bdb86b"
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