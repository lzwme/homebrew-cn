class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.73.13.tar.gz"
  sha256 "2df5fc58593bb38402f848565c611f87bfe42b0d872761efb27c6ac3b20001c3"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a80279db5d1a00535252b7d9972eb894c8e0625694a54e882f3226c7ec32733"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a80279db5d1a00535252b7d9972eb894c8e0625694a54e882f3226c7ec32733"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a80279db5d1a00535252b7d9972eb894c8e0625694a54e882f3226c7ec32733"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f9dcd12f291467e56c17b94329b7c6425997d7afda8fb62266d44830bbd41a7"
    sha256 cellar: :any_skip_relocation, ventura:       "5f9dcd12f291467e56c17b94329b7c6425997d7afda8fb62266d44830bbd41a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92f7d540e1aea3ac460656dc6e009a2533534a2e163b7a303ef70d981c0935fe"
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