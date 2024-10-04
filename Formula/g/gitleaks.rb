class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https:github.comgitleaksgitleaks"
  url "https:github.comgitleaksgitleaksarchiverefstagsv8.20.0.tar.gz"
  sha256 "a1f10bd0389cc256dc5d8add104a446bbddcdcc2cb043621012c6db0bbbfd94d"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6ceca06ae8ee374b2fc8f2e3011208f03dba63057d9df8d6df78b151d671522"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6ceca06ae8ee374b2fc8f2e3011208f03dba63057d9df8d6df78b151d671522"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6ceca06ae8ee374b2fc8f2e3011208f03dba63057d9df8d6df78b151d671522"
    sha256 cellar: :any_skip_relocation, sonoma:        "488699627b89945614350fd5e9722a7f2b8074fa7bf26dbc375d1510e218653b"
    sha256 cellar: :any_skip_relocation, ventura:       "488699627b89945614350fd5e9722a7f2b8074fa7bf26dbc375d1510e218653b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df40d5a90a3f18a881bfe29ca2b47021a9bd771ecc51fcea71c633b457d59ceb"
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