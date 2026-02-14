class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.25.tar.gz"
  sha256 "b14b644f4e1ff9a965850baf6ab3edde0d756d84b2282a398c255593c71cdee4"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d6fe8964c8bcee473d633ce0c35befcd95afbefd988b39cdecc6fcf448186b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d6fe8964c8bcee473d633ce0c35befcd95afbefd988b39cdecc6fcf448186b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d6fe8964c8bcee473d633ce0c35befcd95afbefd988b39cdecc6fcf448186b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7481ed9bda5196e10899f824ce6865ef5bdefeb3177ddfc4b8cdbd9249821e85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5603eea5360431ad92dec7abe8a235af2cadfb6e09b720f7454dd31f43ad9e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cdae96a68ea73cf34b15fcdf3bf499ac518ac4f2b4b91eb581cf71dfdb450fa"
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