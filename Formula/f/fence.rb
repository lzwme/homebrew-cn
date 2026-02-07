class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.19.tar.gz"
  sha256 "57ec93427593a8e6f7df576ba322c761e1cca480e3a19919583a301e1fd68d65"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c909579f64ebe74bfe5df9b224fd1b4e123ab5c896469d30ea8046a24d80512e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c909579f64ebe74bfe5df9b224fd1b4e123ab5c896469d30ea8046a24d80512e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c909579f64ebe74bfe5df9b224fd1b4e123ab5c896469d30ea8046a24d80512e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbcfe8bb5ee9a68ca1e1a300002070798f951913ad34d17e793c84ecdb516974"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb88f29bf144fec6df6e70ace198ce84a936ea26c044b5e77098b05d599e9ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f134b025a232031925946e1b9c677b8312728d5105a7184c01564581d13145b"
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