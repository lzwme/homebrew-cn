class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.75.4.tar.gz"
  sha256 "9fad8712b55a0a8fb8ff965a69a023f1d2acaf279c37e2dcb0597e80face0f70"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e85a856398dd556070a570794d130ee1f3327997d619fe693f9b033ba0f181b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e85a856398dd556070a570794d130ee1f3327997d619fe693f9b033ba0f181b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e85a856398dd556070a570794d130ee1f3327997d619fe693f9b033ba0f181b"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaa81934430a5739cbdf9899882fa25608e8c209bae9e51d2db12993577c22b7"
    sha256 cellar: :any_skip_relocation, ventura:       "eaa81934430a5739cbdf9899882fa25608e8c209bae9e51d2db12993577c22b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c527dfd012ec1f00596283060a38b926fafaa44357f363f8f3633f074494c68"
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