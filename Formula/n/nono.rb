class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://ghfast.top/https://github.com/nolabs-ai/nono/archive/refs/tags/v0.77.0.tar.gz"
  sha256 "beed01f90f54f49877eedc8d87341f18308bf07cff1cb89c8dd290f9c34ba281"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6f7bb93dde31a7ad63e90e7b1567ccedbe09713bea1352f0e667fcdf7ea76f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c319f48f9b94b4004656858fa88456b2e4020df0b1ca35433a362607c55db4ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ea2e0d103c6bd9f9d579d2209c42238779be324438afee450405648b33b6a33"
    sha256 cellar: :any,                 arm64_linux:       "7b85fcc00a32f1314106863087426d7f68426ac68c185e9116d4067c7ea2dd2e"
    sha256 cellar: :any,                 x86_64_linux:      "3d192a5ed38f277bb2b17793736e0be80689964335be390064aa8621d3f02347"
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