class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v2.4.8",
      revision: "377981ebd76e1bbb0dbe07d5428239ec8c5381a8"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed89ce06c30ffdf0b87252abbc40c41c730d6c58a5afafe64000fc513eb9f1fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed89ce06c30ffdf0b87252abbc40c41c730d6c58a5afafe64000fc513eb9f1fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed89ce06c30ffdf0b87252abbc40c41c730d6c58a5afafe64000fc513eb9f1fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e91e0da0723db395aa792057a6bf8c0a03d37896bbf357c1ac1d4a7d16b5973"
    sha256 cellar: :any_skip_relocation, ventura:       "1e91e0da0723db395aa792057a6bf8c0a03d37896bbf357c1ac1d4a7d16b5973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "489fd6e7f29f2c3a777f868d4b527120df164dd035f6689039d42a174f0e7096"
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