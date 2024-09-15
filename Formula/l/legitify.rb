class Legitify < Formula
  desc "Tool to detectremediate misconfig and security risks of GitHubGitLab assets"
  homepage "https:legitify.dev"
  url "https:github.comLegit-Labslegitifyarchiverefstagsv1.0.11.tar.gz"
  sha256 "f63809a93571a72269aed6c10fa3cb1a0f384802857c21740386773690b696bb"
  license "Apache-2.0"
  head "https:github.comLegit-Labslegitify.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d5ed91407468d73ad21a6bd719e4c194fcb4e30d2a06cbbfeac97244e3ed59ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "508603a0320179fd5861ad68d64c4617e13b786ab4f6fc2015902bbb605f3cdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e81db6ed3a3d93d450a249904b883b7b77affdc9d91db30f4134bc705a66ae4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1b329b77085126fb22636d4a9a5ef12c62361c6f5d747713584f227d6c202b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "4da2d4b8cfda747f0c5e4737b420ed649668c3e99e166d6bb09b5ac3ab6987fa"
    sha256 cellar: :any_skip_relocation, ventura:        "b84b18b0af6e823a7e1702a2ae93ddc159c4a663d3a2355736d0d496e1598e79"
    sha256 cellar: :any_skip_relocation, monterey:       "7cd2d8b32f4bf1ab2639d0b62d8400b1bbb7d338961ab5360bfd3e351ab61522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a5928ac45988d42f507bda79350361ac1e2e157ba1957b94df70e1701c1bd9c"
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