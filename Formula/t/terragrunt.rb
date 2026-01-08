class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.97.1.tar.gz"
  sha256 "d458f5e0485c8c3a7072667d769a773d1cf50d902dd6f6b95f1266340be64109"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "854c37abbb531743ca1513e7b1cbfacf29181bb5a3398e6053ed03387608a581"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "854c37abbb531743ca1513e7b1cbfacf29181bb5a3398e6053ed03387608a581"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "854c37abbb531743ca1513e7b1cbfacf29181bb5a3398e6053ed03387608a581"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6681e475a80aa8b62656975cc76f797938c1d1aecd309d268067072d42bda2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1d3916161fc61ec399b4463dea43be8f64543d24dc0646a313cfcec0df6503f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9f395fe43eed615e7bb3feaa07baa9dbced3cb59313f36f9490bcd8bcd04917"
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