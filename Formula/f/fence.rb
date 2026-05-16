class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.58.tar.gz"
  sha256 "7d2f1b20acc44db7b283cb5bc560e58f9cbc7ebf7dd4cfaa98d89260bc3a117b"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97d5c8f1c702a968682299694a6a6abafb6518d002946fcd6038cef56851431c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97d5c8f1c702a968682299694a6a6abafb6518d002946fcd6038cef56851431c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97d5c8f1c702a968682299694a6a6abafb6518d002946fcd6038cef56851431c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0444aca761475d657e76137da79226fec5ddd1d60b7243d5ea13b06bd5b524e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e83b0102bc014f67ecef74478c7ce39b93731e2d31117ef1f8efcc4a6d5bd855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fee7fd8753528be761207a078ad8f0af26c13c2c369da09bcf8eb40775f87514"
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