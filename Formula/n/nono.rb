class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "b97ccfc12c2bcef02e28c9fd5baf1260b4fa7a6b13b766c8df573e120dc8e94f"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c67be80eced086efb3143914faebafeed7c6b641c0686e992fb3ec25013533ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3220454c83b52f3465d2ff1ea987149925b59baae6b080908f26459a2fb1231"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc5d455db6989180357571a67b0fe466c760e2fb469c4dc8ccb44e89d93a102c"
    sha256 cellar: :any_skip_relocation, sonoma:        "556e600c80420724bc383158708d175912ebf93f20d62af26708085f208be34f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc079fcee278e676d1a7452541b1244e90a374e6a2675ecba527694e4bf30411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b43f51681e6e3eba4c78190684d4005a3523d58591102f375ab4b4052765f046"
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