class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.80.0.tar.gz"
  sha256 "4fe42570b6cdd7e417aa0272c660c3f8147061233d4212890ae3a0a13eae35c8"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73a8b32b0e3dff914b7314319bc5699a5794ff62e448c4e73312904917e795fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73a8b32b0e3dff914b7314319bc5699a5794ff62e448c4e73312904917e795fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73a8b32b0e3dff914b7314319bc5699a5794ff62e448c4e73312904917e795fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "70b6dc2e363467b27418a1bff7377b90e3fea6d27ecba9249a6f1af235e2a219"
    sha256 cellar: :any_skip_relocation, ventura:       "70b6dc2e363467b27418a1bff7377b90e3fea6d27ecba9249a6f1af235e2a219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4645c3355b8ff32e42b62fdd23dc25246830ee2da75b9f8560ede874be434cd"
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