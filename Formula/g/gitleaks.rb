class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https:github.comgitleaksgitleaks"
  url "https:github.comgitleaksgitleaksarchiverefstagsv8.21.0.tar.gz"
  sha256 "e4c3009009e5789c2e9e18209fd93b5bd4e12831f442fe4b5ee1b2ed17bf5bbd"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70e0f527b53383771238bc72eadc357daa00f9e8a874099313098607a340cff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70e0f527b53383771238bc72eadc357daa00f9e8a874099313098607a340cff6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70e0f527b53383771238bc72eadc357daa00f9e8a874099313098607a340cff6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6efb87109fe71574b73ef5c5176381598eb4addd1f3642520370559d161d79d"
    sha256 cellar: :any_skip_relocation, ventura:       "e6efb87109fe71574b73ef5c5176381598eb4addd1f3642520370559d161d79d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ef641a680f42d5d784bdd16d564de99d827f178c694fcbd0239d98b865107ce"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.comzricethezavgitleaksv#{version.major}cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"gitleaks", "completion")
  end

  test do
    (testpath"README").write "ghp_deadbeef61dc214e36cbc4cee5eb6418e38d"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(WRN\S* leaks found: [1-9], shell_output("#{bin}gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}gitleaks version").strip
  end
end