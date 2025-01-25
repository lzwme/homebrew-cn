class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https:github.comgitleaksgitleaks"
  url "https:github.comgitleaksgitleaksarchiverefstagsv8.23.2.tar.gz"
  sha256 "aa94b36c695f038cf8a0da8e0f323de1ce4a33067595145e02e76ebc2f459a0d"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8add0d91e5131d75b05a315d6b8099b14ee0887fbb479f49a1d67099ddd66204"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8add0d91e5131d75b05a315d6b8099b14ee0887fbb479f49a1d67099ddd66204"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8add0d91e5131d75b05a315d6b8099b14ee0887fbb479f49a1d67099ddd66204"
    sha256 cellar: :any_skip_relocation, sonoma:        "11c51a32e155115c5e26216e3b36423da82bb8ba2e4cef531daefe3294981cb4"
    sha256 cellar: :any_skip_relocation, ventura:       "11c51a32e155115c5e26216e3b36423da82bb8ba2e4cef531daefe3294981cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab4b5cb9a33dce828f4cc3df41dfdff00114a5af7585f797f80155e1bcdb8144"
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
    assert_match(WRN\S* leaks found: [1-9], shell_output("#{bin}gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}gitleaks version").strip
  end
end