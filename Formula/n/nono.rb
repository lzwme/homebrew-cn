class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "aa17537e8dadb1c5b17edde13f55077cedfa36c371feb24b81b95465774c9a9f"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e1c2d8467ef61da569299d575034994242b80fad4b790de4c956582fef9b871"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af02c415299d2ef233f86532a5d29f8078e5873971793d15505f00ed37230a4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f86cc74a31e18c6c36f58b9c488eba8d7749dd36d70fbd0ba3869522a2eeb099"
    sha256 cellar: :any_skip_relocation, sonoma:        "34aa864527a5f346f1df9f57d614f7e112606cff348deb6aab92127ad83d4a2d"
    sha256 cellar: :any,                 arm64_linux:   "0c4e53be8665e26a3479c24d51510fd6a0f4fac0ad2c86d42a6d53b4da1586c4"
    sha256 cellar: :any,                 x86_64_linux:  "8fbc9297dd5789ee0785f0510d1c7e8bb1ee3db676e1567d4dde05b1d9284204"
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