class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v2.4.4",
      revision: "606c0e724fe9b980cd01090d08cbebff63cd0f72"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "638cd46fc549f4168165db82f1bf882188285eaaca4004aa6229c904676cb5f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "638cd46fc549f4168165db82f1bf882188285eaaca4004aa6229c904676cb5f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "638cd46fc549f4168165db82f1bf882188285eaaca4004aa6229c904676cb5f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "930ff59a0770696683460d2075e501e63c625e8ecefe76ce74bc6348d8516ca9"
    sha256 cellar: :any_skip_relocation, ventura:       "930ff59a0770696683460d2075e501e63c625e8ecefe76ce74bc6348d8516ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f605673bca068640a58b786c499af31655659d0b6325f3e27db03fdad67eca09"
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