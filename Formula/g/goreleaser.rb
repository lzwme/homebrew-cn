class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v2.8.0",
      revision: "734cf912c45da0e5a8442459bb2746c2a946268e"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9f24e771e0b1896e7ef1dbe252cf55c3a85d7c3bf1e8ac5fcadece689e515ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9f24e771e0b1896e7ef1dbe252cf55c3a85d7c3bf1e8ac5fcadece689e515ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9f24e771e0b1896e7ef1dbe252cf55c3a85d7c3bf1e8ac5fcadece689e515ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3afcdab2f96ea0bade06a0f4d4966191ba845d07c7152c8b38d17399efdca4a"
    sha256 cellar: :any_skip_relocation, ventura:       "c3afcdab2f96ea0bade06a0f4d4966191ba845d07c7152c8b38d17399efdca4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d18bc67a577a7d1d226543e133b3c339b72a1ee5a62416821a401fb75216d13"
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
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath".goreleaser.yml"
  end
end