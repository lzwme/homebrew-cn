class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.23.tar.gz"
  sha256 "bbd6a6755f35bb45fca72bf39f448a022419bb18ca831efb0a1f0520687df0fb"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e0cbf33d3cbb36b9f361b673f28292bfa689e4b804e4e9e4601a4c7ae5fc2a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e0cbf33d3cbb36b9f361b673f28292bfa689e4b804e4e9e4601a4c7ae5fc2a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e0cbf33d3cbb36b9f361b673f28292bfa689e4b804e4e9e4601a4c7ae5fc2a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d61c1ba58c6714ab11c0e069ddfd5f06dadde5e6a5218ae1420ffe34330c6f7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b3fa15bd2c68d1ca0be1fd45d5122fe89b24758e9ff6479c4c12c78d64bbd01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb1fd09493610e89d2087468b2a7d852ecdd7f217cfffb8542416b7103265d65"
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