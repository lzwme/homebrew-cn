class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.80.2.tar.gz"
  sha256 "6e56d0b897ea4f849b50eee1e020187af651fdc48a172976ebb6975cdb043178"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44303f81f343a54133c245a597ce0a94067157bb1416dfb399983669b2741292"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44303f81f343a54133c245a597ce0a94067157bb1416dfb399983669b2741292"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44303f81f343a54133c245a597ce0a94067157bb1416dfb399983669b2741292"
    sha256 cellar: :any_skip_relocation, sonoma:        "798cb890da4441adc799eff0f5d7ae9879cf0a8dff68b010ec1473fee2c62a70"
    sha256 cellar: :any_skip_relocation, ventura:       "798cb890da4441adc799eff0f5d7ae9879cf0a8dff68b010ec1473fee2c62a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "562ab7ed2eb9c8c461d266c119d88a3bcb44fd2e29b7b79922bc5c9b0c842a5e"
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