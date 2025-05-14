class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.78.4.tar.gz"
  sha256 "e86148898fe22326bc55a96b0d9c546e7278139afa6bda99cfad4a316bb52866"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2495a6ade32bf8bf3f7a27ec1acde3456c51c6410072009eeaf30344f0e789c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2495a6ade32bf8bf3f7a27ec1acde3456c51c6410072009eeaf30344f0e789c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2495a6ade32bf8bf3f7a27ec1acde3456c51c6410072009eeaf30344f0e789c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5492a59dff9ca9c35f0d8384a460f5286df789434d2ef05ee5e5a840b5a7d81"
    sha256 cellar: :any_skip_relocation, ventura:       "e5492a59dff9ca9c35f0d8384a460f5286df789434d2ef05ee5e5a840b5a7d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5abbe48647b41b8626ce62da33bcad33ab568e128ac2999c4b8cffb790f729ac"
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