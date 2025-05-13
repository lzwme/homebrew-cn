class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https:gitleaks.io"
  url "https:github.comgitleaksgitleaksarchiverefstagsv8.26.0.tar.gz"
  sha256 "08fcf0ec5e7c3e5e8b6c5085df11478c06a4063cb58a64636e74e7f2a2ba903f"
  license "MIT"
  head "https:github.comgitleaksgitleaks.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5cfd2e08b25c761b208bf286dcaae5fd7a5042671d454b0ef91bf04ccca4224"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5cfd2e08b25c761b208bf286dcaae5fd7a5042671d454b0ef91bf04ccca4224"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5cfd2e08b25c761b208bf286dcaae5fd7a5042671d454b0ef91bf04ccca4224"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ec08839532355a07149688e7fbf9b9b6d068ef48c178f9abe20d66e884301a5"
    sha256 cellar: :any_skip_relocation, ventura:       "0ec08839532355a07149688e7fbf9b9b6d068ef48c178f9abe20d66e884301a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb174012f0271f9c3011fcf5d198e3787db559c14b50a8a101287f68d7473f70"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comzricethezavgitleaksv#{version.major}cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"gitleaks", "completion")
  end

  test do
    (testpath"README").write "ghp_deadbeef61dc214e36cbc4cee5eb6418e38d"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(WRN.*leaks found: [1-9], shell_output("#{bin}gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}gitleaks version").strip
  end
end