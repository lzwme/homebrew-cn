class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://ghfast.top/https://github.com/nolabs-ai/nono/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "414f897b8525a003eb37df03186ac79e3e09b4ad0c3be6b4569f985a4a0d092f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e891856b57da7688361c1c32d0524863dc9b9f79ef762bf1ebd210f0e84f3d0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db48597bd78e3406f34bc00cb51239b303aa6674389a5ec8ab5a64357798ea16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "415a6f9ee44bf6fc36089fe23339c21c9b624849f27ddf9dfa0b937d0d0b6103"
    sha256 cellar: :any_skip_relocation, sonoma:        "99a5b568c4057e60de5519d955dea2d84320f954cc27cf73ff0b2ac8ebd371ff"
    sha256 cellar: :any,                 arm64_linux:   "8b9cb3836358595109bed913142d7a33f6dd22b2775849a55216b6dc362d3fd0"
    sha256 cellar: :any,                 x86_64_linux:  "67a1408de3e3b056ec1f0dba3d241b0ae002344bc6ea9363f26cce589eebf46e"
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