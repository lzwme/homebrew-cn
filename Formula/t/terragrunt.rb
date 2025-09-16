class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.87.3.tar.gz"
  sha256 "437223eae72eac54b708179459172f2f8c6c54cb266476284aeef96220b2ca11"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e81fcbb5091e1fdb030f411e5cbb173485490b8a0e976b2e742f9c1822d3fae2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e81fcbb5091e1fdb030f411e5cbb173485490b8a0e976b2e742f9c1822d3fae2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e81fcbb5091e1fdb030f411e5cbb173485490b8a0e976b2e742f9c1822d3fae2"
    sha256 cellar: :any_skip_relocation, sonoma:        "79e3c35ac9f8448cc2b87e749ecaf2abe0400adc801ad159b567849e213797a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6771b053a8ac6d71adaf616e870167d6e383ab9d846e210a93bda31e618819a1"
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