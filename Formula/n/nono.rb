class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "aacfc79e3a3e6745973150409500da9dea53698dd2cca9ecca48e71be1c01c52"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd8e63fd91df4bfc443d3eaed6203948f0ae8f399fd6d7d02c6dd3a1ed546ad0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "710eb3a11e68fee98d59206dd8ff1c7b02adac0a2f9eb9347d3fb084e7392629"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bebb97dc8813f7eed1e583f9d02c9e927bb0ac611a47b903fb4564482a05b05"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecbb7ad6b3a391a499addd3d65ba9515b7fe1b085e482dc31f3dd6b3c82a913d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1599f6b2ca40aaf4207d3eb93037cafba7c04b5de827fa363afb49e413881a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bac81b8676810df69b7518689b386c7845011a0217226ad072ac3d665b97876"
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