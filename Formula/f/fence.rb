class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.20.tar.gz"
  sha256 "01a69878321814fb32677ce949c370ad5417509f692eb2be1c0bb0bda5f026a9"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9faa8c653c4e7fc3592c954f4d80f3a0c92e533b342227eef0ee3e70d86a8c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9faa8c653c4e7fc3592c954f4d80f3a0c92e533b342227eef0ee3e70d86a8c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9faa8c653c4e7fc3592c954f4d80f3a0c92e533b342227eef0ee3e70d86a8c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb0613fbe8c6d6fda210381c7ddf2e55bb4159c01b384e7337bcc289a202f94a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d96b3c98b2b779b4ad23e8055487145c8f8821253a837ffb60c21f543c1f71f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "528eababa4e81bf6fea9c4abfc222e8276722ac2c8746872752ecc09935f7bc7"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bubblewrap" => :no_linkage
    depends_on "socat" => :no_linkage
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
      -X main.gitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fence"

    generate_completions_from_executable(bin/"fence", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fence --version")

    # General functionality cannot be tested in CI due to sandboxing,
    # but we can test that config import works.
    (testpath/".claude/settings.json").write <<~JSON
      {}
    JSON
    system bin/"fence", "import", "--claude", "-o", testpath/".fence.json"
    assert_path_exists testpath/".fence.json"
  end
end