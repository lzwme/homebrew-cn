class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.77.7.tar.gz"
  sha256 "e9a4c067fbf5a3dca62b9ecd7bb7b8916f183d6d7e893fd3cfd6d571b7194e51"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9564ec419b8c272b5effcb63c71e316315d39fb3bcbd6f28d313488c78b2a3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9564ec419b8c272b5effcb63c71e316315d39fb3bcbd6f28d313488c78b2a3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9564ec419b8c272b5effcb63c71e316315d39fb3bcbd6f28d313488c78b2a3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "50ef2fd2e4b7408d95d1fa2127566a44cf045031fca2ed8ddd82e8a6fe7bb59d"
    sha256 cellar: :any_skip_relocation, ventura:       "50ef2fd2e4b7408d95d1fa2127566a44cf045031fca2ed8ddd82e8a6fe7bb59d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28666e685e2ce96e489befa1fd957d24bd1be0a566c36be79b6f5c27cada6ecb"
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