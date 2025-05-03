class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.78.0.tar.gz"
  sha256 "7a6f8d38e80af6c9fd45a8df66449085a847324b8083b0410d68aca83479736d"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0101783032314b2775c0852c13bccc15f4eca7abd14799dd7a06f1628f54c06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0101783032314b2775c0852c13bccc15f4eca7abd14799dd7a06f1628f54c06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0101783032314b2775c0852c13bccc15f4eca7abd14799dd7a06f1628f54c06"
    sha256 cellar: :any_skip_relocation, sonoma:        "055258fe71be0599411c21fdcc28edb615b733b6f3080b170c5a8bde3e100659"
    sha256 cellar: :any_skip_relocation, ventura:       "055258fe71be0599411c21fdcc28edb615b733b6f3080b170c5a8bde3e100659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d78e5b896155b2fc1079cd8210068c82ff097e3f0d4419be2f18c7d886037c0"
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