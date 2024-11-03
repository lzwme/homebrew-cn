class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v2.4.1",
      revision: "1b1a2be4c8059477950350c2775ebe49eaeccd76"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10e1df5810d5efc1a560dfbb6b4ed58c1bb4d40a402f163ef1f62e937fbe92b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10e1df5810d5efc1a560dfbb6b4ed58c1bb4d40a402f163ef1f62e937fbe92b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10e1df5810d5efc1a560dfbb6b4ed58c1bb4d40a402f163ef1f62e937fbe92b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "28309c2033dab0f7af8bc9642a991b35ec32bbb325a1d739dd5e92d5d65c618b"
    sha256 cellar: :any_skip_relocation, ventura:       "28309c2033dab0f7af8bc9642a991b35ec32bbb325a1d739dd5e92d5d65c618b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39649aee49ca7eb71527626045b09e01ae90a8ca4446d120381b4c9375a2304b"
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