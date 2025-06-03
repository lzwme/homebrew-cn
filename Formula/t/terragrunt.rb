class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.81.0.tar.gz"
  sha256 "6254f3bd01562e5d67c3811f324bb4ee58252c8c42d9748f4f0ecf866033be72"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6811e0de0356d9ff7c479dbe5e53691dafcadf6759a21c23c852185eb4f787ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6811e0de0356d9ff7c479dbe5e53691dafcadf6759a21c23c852185eb4f787ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6811e0de0356d9ff7c479dbe5e53691dafcadf6759a21c23c852185eb4f787ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "73fc0c51313c20c03dde41f76d70cd90ebd08c9f3e8d34be028d78d0ff40197d"
    sha256 cellar: :any_skip_relocation, ventura:       "73fc0c51313c20c03dde41f76d70cd90ebd08c9f3e8d34be028d78d0ff40197d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04572cd831466cd21981b4cb60547e650365605de20061721fdd219c09c3304a"
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