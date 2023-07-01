class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.19.1",
      revision: "6b46a1a6aa51e45bd281d55b6e5a2315ee82f643"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81362240f6c690c9c460cf931e2768f4aa49fa9f96c8a36582e54b78395f1c63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81362240f6c690c9c460cf931e2768f4aa49fa9f96c8a36582e54b78395f1c63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81362240f6c690c9c460cf931e2768f4aa49fa9f96c8a36582e54b78395f1c63"
    sha256 cellar: :any_skip_relocation, ventura:        "b9c7d67677d80048442836dd838d1cb544e131773058632fe94f1c6ec5d9df90"
    sha256 cellar: :any_skip_relocation, monterey:       "b9c7d67677d80048442836dd838d1cb544e131773058632fe94f1c6ec5d9df90"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9c7d67677d80048442836dd838d1cb544e131773058632fe94f1c6ec5d9df90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92422e4e51cb1a3c8adefb2751f4910edf378a6ab8dc89e4abbfb918fafc35f9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end