class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.93.0.tar.gz"
  sha256 "e058767360b82d1f37043300ec8ed9e3fd82e4b1bd3ddb42d4cc9def5cbd6f42"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f463fd986f29efdf20a40342805e9ce664f939146a3a16decad15ac062c6ff22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f463fd986f29efdf20a40342805e9ce664f939146a3a16decad15ac062c6ff22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f463fd986f29efdf20a40342805e9ce664f939146a3a16decad15ac062c6ff22"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d7e846af1aad0e3d40f657a8e58174f521464706921d894e4e31b5e82d425b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08f512cecb261227089a4a76547b065264fe6e2eeb211de12ea12d13d792f1a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c49a2ee9462f7f9b6618d8ab3f93b701ba36807c85cbbf33e4968727b77d36ac"
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