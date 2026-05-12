class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "1f506aa02222a1dc627e9ae576bca1387079f5e558deb940ac93e5ffd906e8f5"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94d29b6720ea92f439a7313c448de0e8e10196c90cdd424385794562a4a8cf25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf3cd6f98c0b6d269c901a8967126d0458284a43a97d8f4a3af59d7e846aaf72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1cddb2ff591ec6c607b10f4326c06f3c69c7d308da566ba08a13383f652949f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0887d9b834e1a56a863f01a8c8e0d3301bed3e9cc73182da706c2fc697b39666"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cb64a47d14f82fdb3cf681e16ddcff1fe6190f5c14620ca50b3d07d54d6ea29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ddae53d0c15346e57d2fae10e8158ecb714fc075b1b9782189059683d3879d9"
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