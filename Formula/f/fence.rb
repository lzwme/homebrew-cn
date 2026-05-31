class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.59.tar.gz"
  sha256 "1ac19f56e6694e6c26d672b00814dac509b4f61315c71b9088ed8f7c9ca73bb7"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fcb311bc83b7a94a25ae8f5f279841743a5d6e487436aed70b5a5c5aa78b0dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fcb311bc83b7a94a25ae8f5f279841743a5d6e487436aed70b5a5c5aa78b0dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fcb311bc83b7a94a25ae8f5f279841743a5d6e487436aed70b5a5c5aa78b0dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4caab30b880ce74348735bb0f1648817d3fff379887ac4a5a086c353d5b55e7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f09d9fba0123797d135206cefba93c63dbb77dc8f177c1670bf6910d2a01e562"
    sha256 cellar: :any,                 x86_64_linux:  "e906ab24f9670a914ffa7831d205552950b08da5ec975b3dece5e673a3c9d843"
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