class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.83.2.tar.gz"
  sha256 "230397df702563de3b631ce69be218a99de6415ce91ca34c5786af9cffee9c56"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a90d18437e75224c9995dab5a68e6982f26afec5ce736cac66e9b52ca4285f1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a90d18437e75224c9995dab5a68e6982f26afec5ce736cac66e9b52ca4285f1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a90d18437e75224c9995dab5a68e6982f26afec5ce736cac66e9b52ca4285f1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "810037221d48b50bd5d83db5cbdd3ac1d7398a87fab429d6fc4fd8fb9da97f8f"
    sha256 cellar: :any_skip_relocation, ventura:       "810037221d48b50bd5d83db5cbdd3ac1d7398a87fab429d6fc4fd8fb9da97f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34a7aae1b3a3384759b7364603cbdb4650195579320b68f08ca5fee181ba28dd"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end