class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "4138e6adb20eb19b131e544d4446717d16191462f04555f5256f32a4088e4bae"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7c2463637809ee9064a988169066ca8854997fff39f97ebf6116ee1d79ca3dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbae1ddc6741c628885736f5d9676d8561d25a70311a59c2ed0c24dbe53c7b40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c4ad3a34377161d1500c3d2c673e51c586903f5fafebef112dbc82894f16127"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cfea896245b2dc4d290e660cfdac65d5b29abb4f83c4c0777e9969f893f2fa7"
    sha256 cellar: :any,                 arm64_linux:   "1dcc33335347054ccee2369e539e0d1f8ada1741abc483d2b0b42018a3e49367"
    sha256 cellar: :any,                 x86_64_linux:  "3a80d06038fa9a84b72fbfa830331d61ef1ea661bb322403ac59920db30cd9c5"
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