class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "c466a09a456c3f55aca93d06463d2eaf4a7b59c5e1347aec207b1f155f2db659"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91639d3a31f8254a1350723d30b7bf3344d5ed814d1e4a8ce61a4121d5ca0bcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91639d3a31f8254a1350723d30b7bf3344d5ed814d1e4a8ce61a4121d5ca0bcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91639d3a31f8254a1350723d30b7bf3344d5ed814d1e4a8ce61a4121d5ca0bcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5347015ae8790b0fbd98329d9a27fbc80729978f4b76fcbff4406361ddf6b7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "368351ce83b8a28d5bc629c639d2532a19037c509511170dfe4bf67235bc7176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebaa9a854dc3e1038ed6990ab67f89246f521b34799f1735ee866b33b460ae5b"
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