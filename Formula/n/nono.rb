class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "d5efb1cde828d2a59f0041c91f88a8c48787641fc82776548db622e328828902"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86599aa6e576c027b00f2a20422d0429d266744b4031edbc92cad97f392c3572"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bd8abe37bf094660a814b4f1b7e555954f2fe26d042e04739697436f996f98e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2c366ddfb0ed835cf222dd825a20d477f18b1e1edaac9ba62453985143c9605"
    sha256 cellar: :any_skip_relocation, sonoma:        "52f5f957c900849123adf556319fb6f9bb95edcd2a916251399c0caee6a18183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a40c99be5302e9d3b85f7bc484de3aca90d72cf7568ed19512f9150c2e0eeac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ac99295f6772473b16d440d2009386a2368dd8bbea5e1af76fd5bd1073ddf93"
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