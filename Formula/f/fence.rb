class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/fencesandbox/fence"
  url "https://ghfast.top/https://github.com/fencesandbox/fence/archive/refs/tags/v0.1.64.tar.gz"
  sha256 "575c27b3cf64b3aae6e3149462579a23c1f1ba86547395b0c37f26aabd0f24ac"
  license "Apache-2.0"
  head "https://github.com/fencesandbox/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a3cf49e92e76187105ddff048ae69b40d3365ce376eac134ebaf3127b00059b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a3cf49e92e76187105ddff048ae69b40d3365ce376eac134ebaf3127b00059b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a3cf49e92e76187105ddff048ae69b40d3365ce376eac134ebaf3127b00059b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5dc0e6fda51364a83ab09a485933f76dd3db585228306dfcc837285ff61289f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e3b4e1e628586a993101ae2fa64c2cb9c0a461ca07b1afca1b9ca1890f80740"
    sha256 cellar: :any,                 x86_64_linux:  "27fd2ce218e36229595a5c51ce4b4a3b0d8420094ffade97347ff80a677e66fa"
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