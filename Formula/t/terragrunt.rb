class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.73.11.tar.gz"
  sha256 "fcba470895a499d689624f236825a3aea0b0e44962db45aadf95e48a8e7d107e"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b73195ba95d19c9cef0041a10b3d54fc5b68840524b4978034704349ef7f7dbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b73195ba95d19c9cef0041a10b3d54fc5b68840524b4978034704349ef7f7dbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b73195ba95d19c9cef0041a10b3d54fc5b68840524b4978034704349ef7f7dbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "73aae11077fb79bb1032518c28bede4bbc4df203aa3ce2765c677fe35b5a4d30"
    sha256 cellar: :any_skip_relocation, ventura:       "73aae11077fb79bb1032518c28bede4bbc4df203aa3ce2765c677fe35b5a4d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6bf3aa820b85776623096cc32c823867ac232444f41078af44373bf08bde603"
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