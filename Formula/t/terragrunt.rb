class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.75.2.tar.gz"
  sha256 "670b3aa270da43e72f13025118c1d1a6df66a153258c6e576d661d7c32dc06ce"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48c7a6659daeda359ffac31fca30e5946b020f5fcd0bce895fa14373fb9b5808"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48c7a6659daeda359ffac31fca30e5946b020f5fcd0bce895fa14373fb9b5808"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48c7a6659daeda359ffac31fca30e5946b020f5fcd0bce895fa14373fb9b5808"
    sha256 cellar: :any_skip_relocation, sonoma:        "050cceb0baf00e62a274748ab9573e14dc160434632fdef2e8562d438b9c9d23"
    sha256 cellar: :any_skip_relocation, ventura:       "050cceb0baf00e62a274748ab9573e14dc160434632fdef2e8562d438b9c9d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b7bc085d57af6b82497727d8a81655553217320244d46ed384dcddb9563bf0"
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