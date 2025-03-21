class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.76.3.tar.gz"
  sha256 "2f5b712eed65e9fb9e2b35153e9b3466b9a7432cbb2430f33ab8180da1536b6a"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e3554f1dc6abaa47ac0669de4dc8341e638f73455de5407cedf2e6cce24b129"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e3554f1dc6abaa47ac0669de4dc8341e638f73455de5407cedf2e6cce24b129"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e3554f1dc6abaa47ac0669de4dc8341e638f73455de5407cedf2e6cce24b129"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5f3f9d2105131e8b7b0bde60ce78d96fca5155dd44c5fd00d9d9e4a143e51a3"
    sha256 cellar: :any_skip_relocation, ventura:       "d5f3f9d2105131e8b7b0bde60ce78d96fca5155dd44c5fd00d9d9e4a143e51a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "828a581bd188140760d7db003a3478c1cfeb7f82bb5618526b61a9c61ad54ec3"
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