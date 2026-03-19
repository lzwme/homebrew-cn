class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.35.tar.gz"
  sha256 "4840e001138231f20bd0a4094a9dc9d8d712c07ed2d8652c196dbdc8de39bae4"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3f22a461422c8bec0a4714391490b0352bfe25fde711dbb5755d62b03cff10b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3f22a461422c8bec0a4714391490b0352bfe25fde711dbb5755d62b03cff10b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3f22a461422c8bec0a4714391490b0352bfe25fde711dbb5755d62b03cff10b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e859edd41ed853db5944699d4bad51c8d4a7385165ae8a4fc3769a1da9b7d3b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0573bf599b3e60c68901d35b77a5ca63184d00c1d4d09d32cf16ab63f373826b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65eb8b9a8e626f3510185400803c766dd6a718282329de3db7d55fafa46bab2b"
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