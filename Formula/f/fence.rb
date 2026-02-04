class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.18.tar.gz"
  sha256 "ef6ba01331dbe6a7aa2bb9da05cf1ebc1a894b1a6626560c3148a12142a54aa4"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a0a3be895a7121c825f386afcdbb896d6eb01d18983e493963c0b0be3498013"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a0a3be895a7121c825f386afcdbb896d6eb01d18983e493963c0b0be3498013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a0a3be895a7121c825f386afcdbb896d6eb01d18983e493963c0b0be3498013"
    sha256 cellar: :any_skip_relocation, sonoma:        "d633850d3502058799b20896a6e40625e8f5213c371cb969375b980f9b5191a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79a88d5f9c9affca2b76b570cab880a8a56527c600de313592d5e621a214e74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "001e3f1d24358991571be4d8a7f757dee20bf5d31224d0c0ab37a064d956c587"
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