class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v2.10.0",
      revision: "5014328cd6593ee3d003b8857c57d519c77ead1a"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f7b0cbacc1d6ce2754f5baa99298935ee4d85435e98e8c0fa8cd47979cf0ea6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f7b0cbacc1d6ce2754f5baa99298935ee4d85435e98e8c0fa8cd47979cf0ea6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f7b0cbacc1d6ce2754f5baa99298935ee4d85435e98e8c0fa8cd47979cf0ea6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d0248df9111cde533ccb173566c6b96bdd182aa086bbacb4ebd8606cb1b4816"
    sha256 cellar: :any_skip_relocation, ventura:       "51e2a341b1338fabdda14716325a039cd860c947f3dfbdaf91719c41828e15f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f255ea10249cc4c1dc4e6250fc81e20335603708eb23dd4f25417501f42180c8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
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