class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v2.3.1",
      revision: "c16bd531422325846d4c4f546d68dff4374e963a"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d579ce43954b0ef95704bf4d3ba9039b2a2b1208d1976eb6b262d3c98e28e57a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d579ce43954b0ef95704bf4d3ba9039b2a2b1208d1976eb6b262d3c98e28e57a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d579ce43954b0ef95704bf4d3ba9039b2a2b1208d1976eb6b262d3c98e28e57a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4d229f5a66c8a9477ef0563e57683098dd2201ff42eb7dc00546750ddd3e727"
    sha256 cellar: :any_skip_relocation, ventura:       "b4d229f5a66c8a9477ef0563e57683098dd2201ff42eb7dc00546750ddd3e727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a58a4ba0f3eefaf0a9b4f580b94737527ba0d1468ad34b4f0a74c330d8e208df"
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