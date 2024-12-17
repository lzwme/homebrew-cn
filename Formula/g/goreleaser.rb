class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v2.5.0",
      revision: "7339ef1b4aeae3ba84d4f125fa762b22c59a1c30"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29e4e0ebdfb51aa7bcd0747fb34943ed90c651fecb6c1cb1b9ebd65be2563d29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29e4e0ebdfb51aa7bcd0747fb34943ed90c651fecb6c1cb1b9ebd65be2563d29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29e4e0ebdfb51aa7bcd0747fb34943ed90c651fecb6c1cb1b9ebd65be2563d29"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5eed19a46a1865ec2a2ccacb20664e8194d9181c1916c094b285a6d6d818f12"
    sha256 cellar: :any_skip_relocation, ventura:       "d5eed19a46a1865ec2a2ccacb20664e8194d9181c1916c094b285a6d6d818f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d3f2733953690551f8d9ca2cd25a6551bb64c44971a1e9b454310c6aa38236a"
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