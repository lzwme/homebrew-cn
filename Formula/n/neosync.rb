class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.41.tar.gz"
  sha256 "0f0cd76df6b35b6751d8a5b9acae4e5a6f16651de3aa27ae0b76c915286f81b1"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5967c0da08ede9f73f17f28af35e0bb302b3f34b77de7d5258930a77ee6e99e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6dadde227a77d6192d1ecd332d70aec2fc649550fca48867c39e2db971244e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6de2ed34bc83b28f76baf8c5f371182678a2108c6eb8cd21caa7534311304edf"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad2385fb5f0529cdcd5722cd1b5e75f13a61dea8987ff5559963369d07e09ffc"
    sha256 cellar: :any_skip_relocation, ventura:        "8631ac797204f8c9985cd8591fab939876bf18a9fd5bab30eb3dbbadb5474c8e"
    sha256 cellar: :any_skip_relocation, monterey:       "d4fa9cf96ae93202cfad423476ea039bfc439cd06e8104edee171739f0790d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9c854cf9cdeabd51e47b3168ddd277f7b97f341e571bb6ea72b8c07a4794ad8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end