class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v2.4.7",
      revision: "700889269f740f659c9f3867f2b79fed677b74b0"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6abbc9465f83f72022a5ccb1eaf68d6b22cb35c078044538c939afe0707caa7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6abbc9465f83f72022a5ccb1eaf68d6b22cb35c078044538c939afe0707caa7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6abbc9465f83f72022a5ccb1eaf68d6b22cb35c078044538c939afe0707caa7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "24f02b4ae33e710e1b9faa7fcadbef40b5f95fb0cb52b172906cd0402963d562"
    sha256 cellar: :any_skip_relocation, ventura:       "24f02b4ae33e710e1b9faa7fcadbef40b5f95fb0cb52b172906cd0402963d562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b61b4bfe7a6feef897bcc0767cd1569e1267e2037cf53f46091442d6e573cc3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath".goreleaser.yml", :exist?
  end
end