class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https:gitleaks.io"
  url "https:github.comgitleaksgitleaksarchiverefstagsv8.25.0.tar.gz"
  sha256 "c186ca129f2315625bf5db4fc3f60c65557c51a4811586fd1b50a619be945935"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b495b6f11c4f2aeaa22fb0d42a367b3f35ac4dedfde952eef8b88d3e0e5aac3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b495b6f11c4f2aeaa22fb0d42a367b3f35ac4dedfde952eef8b88d3e0e5aac3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b495b6f11c4f2aeaa22fb0d42a367b3f35ac4dedfde952eef8b88d3e0e5aac3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f3b74098f91bdd76bb81dc7af94c13a1740aafef715f92f569a70d729df68f1"
    sha256 cellar: :any_skip_relocation, ventura:       "4f3b74098f91bdd76bb81dc7af94c13a1740aafef715f92f569a70d729df68f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76c6dd1177a61d6b8770b50427672a9b7d3b1fa7911f76efca0749a47f9bf2e3"
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