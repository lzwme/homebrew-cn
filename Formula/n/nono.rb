class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://ghfast.top/https://github.com/nolabs-ai/nono/archive/refs/tags/v0.72.0.tar.gz"
  sha256 "325b1f9a671c5dc75cc5eb1e54ac0dbafa0b067a5fc8ceb375d42654fe547a04"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "100181b01079460f9f2c00bada9a5a3cfabfb69dc626a02627e71bad98ffd522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70ecc6c2ebbbbcfe7010b8b0d9aba9ebf62b7c273f170785b5c5041556731495"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da4ca5c4663d3a67e0be548e6551be0d1aa3a978b7cee816e900b6cd2f9031ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "46d8ebb96d7774635bc409b7342ae141e0a7a710511bddf266dda3ecbc1b0c73"
    sha256 cellar: :any,                 arm64_linux:   "a35b86c022c3ff5e5f56916c95b2a41ac9f2296e1e47638ceab5f8b7d6943d77"
    sha256 cellar: :any,                 x86_64_linux:  "1ac8e43356a44ccdac2f75a70db7385c6c69daa9253cfb9c27a573386243899c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
    generate_completions_from_executable(bin/"nono", "completion", "--silent")
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