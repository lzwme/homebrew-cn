class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.16.tar.gz"
  sha256 "6ba44fc5b9df27dea1e98d79be8dd4a4a4d8ead300108dec8647d656b8e98baa"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc4331fbd9ad4b677fda1734b4a66d0bfd0539c9ecd9276f67d292be97d29066"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc4331fbd9ad4b677fda1734b4a66d0bfd0539c9ecd9276f67d292be97d29066"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc4331fbd9ad4b677fda1734b4a66d0bfd0539c9ecd9276f67d292be97d29066"
    sha256 cellar: :any_skip_relocation, sonoma:        "439a9f7d18d734dbe892936ebabcc15da0f5ba65bcece368fbdf4fa1f0ef73f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d8381e129eb0fcce47a01cc2b7149661c2b530f557a145f466b0540be7d7cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f52a74f4630db8353d38bfbe705a7ab21de91f7cdb5d72a89d13a37aee4a25e"
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