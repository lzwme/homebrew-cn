class GitFlowNext < Formula
  desc "Modern implementation of the Git-flow branching model"
  homepage "https://git-flow.sh/"
  url "https://ghfast.top/https://github.com/gittower/git-flow-next/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "ff6cfd247cf9cba51c695ea95a061522b537cd3b3ba10219e85e07a567273420"
  license "BSD-2-Clause"
  head "https://github.com/gittower/git-flow-next.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "890812fb397a264cfafd940f7c03ef62a4c84409213cfdeb596b8af49be501ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "890812fb397a264cfafd940f7c03ef62a4c84409213cfdeb596b8af49be501ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "890812fb397a264cfafd940f7c03ef62a4c84409213cfdeb596b8af49be501ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0e487da5229eae7fe2e4afd22c615ab97a51ec0ccfd460c7e4fe4894f965166"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed883110679862a36420641634f2d6740a89dcff3336be7824e74d8dda7b5ebf"
    sha256 cellar: :any,                 x86_64_linux:  "c3b4c135d13898bdcac841f22511836cf2a44a957d22ecbdf153a3631795863d"
  end

  depends_on "go" => :build

  conflicts_with "git-flow", because: "both install the same binaries"

  def install
    commit = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -X github.com/gittower/git-flow-next/version.BuildTime=#{time.iso8601}
      -X github.com/gittower/git-flow-next/version.GitCommit=#{commit}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"git-flow")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "flow", "init", "--defaults"
    system "git", "flow", "config"
    assert_equal "develop", shell_output("git symbolic-ref --short HEAD").chomp
    assert_match version.to_s, shell_output("#{bin}/git-flow version")
  end
end