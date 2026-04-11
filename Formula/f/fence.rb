class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.44.tar.gz"
  sha256 "4b63ea3b6484a57b544bde7c1df23b793548468a738875ea986cbbc7292fd544"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "483b3bdd75a7a8e57e307144689f83e1205a130ef4d6a8b270a356233f0a58a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "483b3bdd75a7a8e57e307144689f83e1205a130ef4d6a8b270a356233f0a58a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "483b3bdd75a7a8e57e307144689f83e1205a130ef4d6a8b270a356233f0a58a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0432f888a83c5858702b00d6f0cf62ca9404d804edd629dd8f537ec5443b2414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa555a3a6eb503e332af7eb3bdd4e5a5781c12022da73b3602f2db673d5843cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3af940e57f494802c53ccc21bf2a45bdaf708fc8a41535ae9880bdd5459dcc44"
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