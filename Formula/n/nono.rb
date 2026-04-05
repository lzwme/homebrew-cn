class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "e2dfb04d283615270cb77f8b133342ec9c5b910327a8d234a7070c9bd1f777ea"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c61307d78dc4a261e05f68c3121d86a668f0f17c40040b43205d1a5ef2739b80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da87a83f7c1d2e0a20351eace8cbce1820b4be72a4d363ab2c6383a6269e300f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78a58ae511499e805094beacbc8cad1eeb1e4ebf866731a644dbb7f32ee9aaf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "58197a5fdb13c37f3d0fc143725e93531bf81449219722f6b3bf48d759dcc9b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d40f82fcf1d5aaa1495b21a97ac5c4aa62260e1dcd4c8bd4d6e16c2ab491a35d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf8ac8236da19f0bfd4938261474ac0f406b416c662fd0c19f491050f5e8e245"
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