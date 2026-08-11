class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://ghfast.top/https://github.com/nolabs-ai/nono/archive/refs/tags/v0.73.0.tar.gz"
  sha256 "7a14caa7b3149e0131e82a86b030597dc20872c3dbafdc8686a160dda63a6eb3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b11a182d26687b54fe49e91deae085aaa1615d6013a2084bd660cb4a1e68240"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ecd0566dbf60b072012b9d20930d0a0858999ef6e112a099361b17a13f76596"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17fbd770d163636d2d56fe14e07bdbfb9e7d197f7a041c75b5bff3e6e3bc89d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "be78cb7983e69afef3d961515e0ccbf6a1ed4c1418b9ba7c9f1a1edc00a3dc10"
    sha256 cellar: :any,                 arm64_linux:   "ec0193ab7596b83600926ce328f26d140672f9f66d1478efe34ab73f5a28cb5d"
    sha256 cellar: :any,                 x86_64_linux:  "13adaae05b00ff32f2c30db6e41b0ceaccc0d737d1fb483f50feb9caf83ae0e1"
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