class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://gitleaks.io/"
  url "https://ghfast.top/https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.29.0.tar.gz"
  sha256 "c6c1dd94896f1b6db2172ff4d61690f59a1a4546ae28d8ad42337cc63a90f671"
  license "MIT"
  head "https://github.com/gitleaks/gitleaks.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c650eed9374f41abc1ca638a31041dd9d46e87f5de3862c08965a7683fba3001"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c650eed9374f41abc1ca638a31041dd9d46e87f5de3862c08965a7683fba3001"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c650eed9374f41abc1ca638a31041dd9d46e87f5de3862c08965a7683fba3001"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dd9a4725e82c18b730c99627f7c93bb3ad67b5a7ce0930178226b6d5b7d9b44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc0055a696e64baa84e54804c2c9d41c207e3ace5e87c93cf9a65c7fae822841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3985dce983b9a6f8d884830e3e7736bde92f167eb6b8db8c6c2c2f692a469509"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/zricethezav/gitleaks/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gitleaks", "completion")
  end

  test do
    (testpath/"README").write "ghp_deadbeef61dc214e36cbc4cee5eb6418e38d"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN.*leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end