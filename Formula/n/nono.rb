class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.61.1.tar.gz"
  sha256 "5c6d1898b4992a9c2d24a2d58be82b0539a20ccb265dadf3d9244ab1d6d1982b"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a2df79f40d6cd82ce4131329f0a7b14a71a8bb5119fb29665c5bf497eaa6171"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25d8fc61e2421f5eaed943cf0ec2e400e438b10bc5b69283e402e370960a2bb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fd4ca731c29e27ac38df4f07dfb0756d1d8e73e07afcea8356761de18f410b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9cca0f25683752971af859906ce182e0ebe184b467603eb0dce4766057e8a68"
    sha256 cellar: :any,                 arm64_linux:   "4efefdf368591386b7366f217045a87d7e15982a47763553984dcb51876dadd3"
    sha256 cellar: :any,                 x86_64_linux:  "7024aa1e8bedffa2409f38d2df27d09a41a3da594e81ac47c143544ef0583739"
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