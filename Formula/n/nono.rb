class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://ghfast.top/https://github.com/nolabs-ai/nono/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "1d2a946a0d4864d95a2835cbc764bc1e0a91237242c5e0cef9ef81abebfc4a3d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcfb0f378d4861fa519926cbaa7b7f08d8a028cd8e8beb740af37c3d5a9bd321"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23a4f5a6b0ddd5edd390cd3d76f8b925fbe67f463d0b0e0adb79bff7f44c4e1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfdf049b5c2adc7b7283ef1eb291627ba7f7e5600a132ed781ac2d59d66cd9a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a833cf36197f905ddd3d195d1ca77018fc71f0dd42aa9defeddce6560056b410"
    sha256 cellar: :any,                 arm64_linux:   "7cefd3c82ec41d3123bdd41e4deb84cb3a02996fdbdec80d751240d11e670d9a"
    sha256 cellar: :any,                 x86_64_linux:  "07838bd04fbf3d54be545a45fea7f9ae9fc03b769a64b601a1466b7ec6ab2694"
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