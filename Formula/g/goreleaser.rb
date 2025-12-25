class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.13.2",
      revision: "bde54b47f0e27169880d43a8469f4d805942e2e3"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4665ed44fce9f84e7eb769cec2a64c74abbc9ff50b636ee7079261d3bb4437be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "598d21d0db2e8584595cceb06b9c274b6939fb132b6526208fd2b08fb7d656ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea00c1686ae67d6e13da8e43bc2b9f5f05259b470c9ba6867c7a55dc20146f25"
    sha256 cellar: :any_skip_relocation, sonoma:        "df77cea7065c36b59bb695079176dcccd0cb6119783ce922f40f86a3fcaae399"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "224a5756acf173329f80efaaca5bbfec2bf843e3a8f34f0bf326b0609f60917c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7d8b91446d50fcbe543976ce0b8df3cc2f0bf9dc978cacc5d0cc4c9f0af3972"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end