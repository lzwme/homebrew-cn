class Legitify < Formula
  desc "Tool to detect/remediate misconfig and security risks of GitHub/GitLab assets"
  homepage "https://legitify.dev/"
  url "https://ghproxy.com/https://github.com/Legit-Labs/legitify/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "7113a4f937c8ecf6d0071ad2e82956d0db9a88d66c194865ebecfac8a6aac409"
  license "Apache-2.0"
  head "https://github.com/Legit-Labs/legitify.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d43b5a925f494950fbe650a31cb098238f2af4ad1e20c4a9f2056e03befa5e98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e68ee8b4391dcf8625e77639a2b22390ed28345d27a664ee3516531522bfd4e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4da1d5b406ec12a66916f41c7480cd2a8cc9c5e0c7ed218f9578caf825e6017b"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc6d32dbc64f01f8b0dc6e7288c6dcf5e81871a634343fe195d090188bc294bf"
    sha256 cellar: :any_skip_relocation, ventura:        "7a6a136dc2f45f2b597155ea85a5b2a34e78c90badd442c556ee5c29f9ff103b"
    sha256 cellar: :any_skip_relocation, monterey:       "0fad12deb41aa5ad8f25556f1dcaf1cd6031a725b100dc45be33567c68c73d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07b9cf02e9715d48589fa2763a27b43de19188f3f2e6655d4ca8fc663598027d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Legit-Labs/legitify/internal/version.Version=#{version}
      -X github.com/Legit-Labs/legitify/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"legitify", "completion")
  end

  test do
    output = shell_output("#{bin}/legitify generate-docs")
    assert_match "policy_name: actions_can_approve_pull_requests", output
    assert_match version.to_s, shell_output("#{bin}/legitify version")
  end
end