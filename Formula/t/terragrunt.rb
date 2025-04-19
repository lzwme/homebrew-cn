class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.77.20.tar.gz"
  sha256 "472b239a7e394bd4706ae1077741f3e4bc7ea0b32d121bcaa9b83bb2ab54f5fe"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85d7b48a44cfadd79f922c99bd65f4230b9bbb9558a9521f0220b42a684aae8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85d7b48a44cfadd79f922c99bd65f4230b9bbb9558a9521f0220b42a684aae8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85d7b48a44cfadd79f922c99bd65f4230b9bbb9558a9521f0220b42a684aae8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4206442f8d30950dbf699b152ffadd42bc3ee01b1d38d4470ce897726ebb19cb"
    sha256 cellar: :any_skip_relocation, ventura:       "4206442f8d30950dbf699b152ffadd42bc3ee01b1d38d4470ce897726ebb19cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "828299cd78e0ccef079b622e988f8ebb082c888b0e77fcce3f9fd13f4db5fd43"
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