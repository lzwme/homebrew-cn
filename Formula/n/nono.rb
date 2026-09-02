class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://ghfast.top/https://github.com/nolabs-ai/nono/archive/refs/tags/v0.75.0.tar.gz"
  sha256 "96f13cbd3f880bc91fd77b2d076fecca7b80ee7880f5f15e5c6ab2f746d2a823"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2928be50f6b55f94beca87640091c6933e7560ea21d602e8031e4445cdc4f96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d550258f17fd65d3e44fff5a81a4a55165c8677a1c224a073721d235069250d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a7daaa0e9531d036627cc9a06b12f5982cb9ac661a9dd7896d53a1d9f1c7089"
    sha256 cellar: :any,                 arm64_linux:   "3b5b550bb6685f49e49f0bc5b2c2397a840047db15fd57acb405495f541a5fc3"
    sha256 cellar: :any,                 x86_64_linux:  "9d680618ae9e845a27ffcb734259860028bfe172396260f1c5edd055afe23c8c"
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