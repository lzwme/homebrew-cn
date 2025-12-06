class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.93.13.tar.gz"
  sha256 "db757ce97530850184c00e52727208a8097a477d5b9e34cd95ba1924728e5ac6"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5585eb5eeb6f2f802e4fdaa49aff6664d3470ace401dfe6c0c42cff9f1e32a02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5585eb5eeb6f2f802e4fdaa49aff6664d3470ace401dfe6c0c42cff9f1e32a02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5585eb5eeb6f2f802e4fdaa49aff6664d3470ace401dfe6c0c42cff9f1e32a02"
    sha256 cellar: :any_skip_relocation, sonoma:        "f646b16edeb3db7d4c1ce5e353b8bad935fc8bb908ae1f688f40c5344b861c2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91f3fc39a942b5dfa8cb1665fafcb69d352b3c3251873ab3e06836c1dc949060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fd0107e0f103090c4aaecf6a1ee367e64ba4f2b9fa56a72a5b1862b795411a2"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end