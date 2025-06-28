class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.82.3.tar.gz"
  sha256 "7b5689b06fc14ca391452645d88e4d8a22f2fccad1a2a7ac406a366eb4319075"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "620d84e46611b742a7ba0aee707b5f33936393381538725e78879b6576478af1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "620d84e46611b742a7ba0aee707b5f33936393381538725e78879b6576478af1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "620d84e46611b742a7ba0aee707b5f33936393381538725e78879b6576478af1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cfe98dd081d58c535ce5935cd041fef6cfc94a665f738f30ad12bdbd68c89bc"
    sha256 cellar: :any_skip_relocation, ventura:       "1cfe98dd081d58c535ce5935cd041fef6cfc94a665f738f30ad12bdbd68c89bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87433e17c634491ba4751e6770e2c945ab933aaf1bb9153f95575999bd83f01c"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end