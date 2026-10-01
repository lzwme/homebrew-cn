class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://ghfast.top/https://github.com/nolabs-ai/nono/archive/refs/tags/v0.79.0.tar.gz"
  sha256 "8aaf669401a0d0084d2e6da79468efe067cbd220d3831b42d46085a312df50aa"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13adb3656763f84d27d2e20abeb5b41dcc76d6a5cccdaee12a5a4a1343713368"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2b536a26147176de108277d2dadbab2bcae81698d31287680d244c645511720"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "525d7a8351d5fbb630aa65c470d16ede9a5a356b17762bbf4475ddfe2aa1b017"
    sha256 cellar: :any,                 arm64_linux:       "83ded978c41d3425812788e05349563a42ca7c1e146d6ab4959c9b366832f556"
    sha256 cellar: :any,                 x86_64_linux:      "7c0c790ad27e84930aecdc57e469179c0202bb708a2a233163d09ce43fed56b5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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