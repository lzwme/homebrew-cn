class Legitify < Formula
  desc "Tool to detectremediate misconfig and security risks of GitHubGitLab assets"
  homepage "https:legitify.dev"
  url "https:github.comLegit-Labslegitifyarchiverefstagsv1.0.9.tar.gz"
  sha256 "47c8b8e7356cc7dd0774d7b0eb30f58fb82a59ff6c86e0aeebe4b24e21a8a19c"
  license "Apache-2.0"
  head "https:github.comLegit-Labslegitify.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "727bc2ab7d1e6e20c441074d0937000605a163e951bd8295be91aa764b6883ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f90bd74f9b5d7a840e98828a4ad2a9515d2cc5da24901355cafe2c7fb7160096"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "030b7fcb6433e725f39940c050103c9c8e3ac39b2a56b400c1c186603b88778e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d7547612b0a4251c39d4d333c2ad01e95b145ccc51c937f2531dcce25ef8a3c"
    sha256 cellar: :any_skip_relocation, ventura:        "2c2280c694ced470b8af9b9abbb173d7dbe4fc8180943d7c2ec51788fec124c9"
    sha256 cellar: :any_skip_relocation, monterey:       "e688b335cb6b76cb04c59b9c57e61b33179a320d6031aabc9833ba417e6da056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e11ccc72c859a4272aff81f5137d4db86153713f34cff3db02a7b278f3f2cc87"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comLegit-Labslegitifyinternalversion.Version=#{version}
      -X github.comLegit-Labslegitifyinternalversion.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"legitify", "completion")
  end

  test do
    output = shell_output("#{bin}legitify generate-docs")
    assert_match "policy_name: actions_can_approve_pull_requests", output
    assert_match version.to_s, shell_output("#{bin}legitify version")
  end
end