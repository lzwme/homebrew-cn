class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/fencesandbox/fence"
  url "https://ghfast.top/https://github.com/fencesandbox/fence/archive/refs/tags/v0.1.65.tar.gz"
  sha256 "abcf2c8a165455f15c09509f53a273f1261e645384a21cc24b30d47009254b10"
  license "Apache-2.0"
  head "https://github.com/fencesandbox/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cc88116a3b6ca693fb9d06308e7d5b3a85f9f105252eeb4d3157e550c9d5a14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cc88116a3b6ca693fb9d06308e7d5b3a85f9f105252eeb4d3157e550c9d5a14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cc88116a3b6ca693fb9d06308e7d5b3a85f9f105252eeb4d3157e550c9d5a14"
    sha256 cellar: :any_skip_relocation, sonoma:        "931a14881b473399d7696a15427856983f79c343a305f83661873c0ec4bc0dbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75576674c1264d47ccf2c95ec03c132fe350a8129a163738c7039e3f0d2aa40f"
    sha256 cellar: :any,                 x86_64_linux:  "3cdd78cbd5156c9184ece0ca6620a73f53f0cba91a781c5c12104d298daeddd7"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bubblewrap" => :no_linkage
    depends_on "socat" => :no_linkage
  end

  def install
    ldflags = %W[
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