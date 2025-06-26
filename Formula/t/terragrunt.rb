class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.82.0.tar.gz"
  sha256 "cb2aa1449101e357a6d7797780407167ef4eb8e7a2b83b91e8fbc92c43214c8d"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e2d86193e15c6d6ddb2286ae0e18cd51026ee4a262d856e3c01851961295989"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e2d86193e15c6d6ddb2286ae0e18cd51026ee4a262d856e3c01851961295989"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e2d86193e15c6d6ddb2286ae0e18cd51026ee4a262d856e3c01851961295989"
    sha256 cellar: :any_skip_relocation, sonoma:        "42dae5cdb2c75f28cbffd7999dbf835223d0ef910b675baa3c3f7e98db7e5c26"
    sha256 cellar: :any_skip_relocation, ventura:       "42dae5cdb2c75f28cbffd7999dbf835223d0ef910b675baa3c3f7e98db7e5c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70478594eb489dbc8d46366ce3b2cf11f022179afac2d643be145bc9aca60023"
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