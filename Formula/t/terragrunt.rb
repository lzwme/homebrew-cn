class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.81.8.tar.gz"
  sha256 "e41bcfdefaf0daa76ea481d9a796ce2a64c6fab588ea5dbbf1c64f4e9dfb83e9"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c844d1e3a54aa95a5bef7b44f567f15a1ccea0c7f802fa3e0108d5c6d9eb3e5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c844d1e3a54aa95a5bef7b44f567f15a1ccea0c7f802fa3e0108d5c6d9eb3e5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c844d1e3a54aa95a5bef7b44f567f15a1ccea0c7f802fa3e0108d5c6d9eb3e5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "be6745832a8ae4a1a1a9f451474882d00dc7b38cc09c9b54cfbe362e9e653482"
    sha256 cellar: :any_skip_relocation, ventura:       "be6745832a8ae4a1a1a9f451474882d00dc7b38cc09c9b54cfbe362e9e653482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc48d312fbf50d0505606ef06da55da20ee0c8bf27c765677f628c03dabac6db"
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