class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https:github.comgitleaksgitleaks"
  url "https:github.comgitleaksgitleaksarchiverefstagsv8.19.1.tar.gz"
  sha256 "163eb1afe949220e309496492e271d9c905954420beb646fbe24289eb1567bc4"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74cb45c9421b8a4725ce1842f56a638b2a434ea499045eca896ed5cdf2ed57af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74cb45c9421b8a4725ce1842f56a638b2a434ea499045eca896ed5cdf2ed57af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74cb45c9421b8a4725ce1842f56a638b2a434ea499045eca896ed5cdf2ed57af"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fc3f14c5524cb0b7a7d320072eac4a62352d1e2f4110aaef0f6090ecef928b7"
    sha256 cellar: :any_skip_relocation, ventura:       "8fc3f14c5524cb0b7a7d320072eac4a62352d1e2f4110aaef0f6090ecef928b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f8df67b54cca7bc71d52e8e91fda7e89f91322945238ce83dacdcda87e3692"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.comzricethezavgitleaksv#{version.major}cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"gitleaks", "completion")
  end

  test do
    (testpath"README").write "ghp_deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(WRN\S* leaks found: [1-9], shell_output("#{bin}gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}gitleaks version").strip
  end
end