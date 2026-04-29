class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "afc6d23551ad4898a69fc85bb30880e6e5ef47c206cdf7125d03305bea1e21a9"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30d3437597af5af72099982efd1f4a15a852199dd0ab8d83163b910ee2ed4bd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "221ae3fefc51440a137b461be779af217a205345c114973dcf5e19f3d6d31c3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb14e7cd8a17fd4da8bbefc31243fac6485ee6d39e69f2d1981f45dc360183ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "f737bfff5108c6642a184712b004e167747ef223e9c767277d9d7413834ca9d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ff44d50d043d6d70d11eb290683223c56a3110bfa33d68db9dfa0997e82766c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01cbffb33d79cd7ef699386107554d9e54165afd523ad7684da2628887b6edc9"
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