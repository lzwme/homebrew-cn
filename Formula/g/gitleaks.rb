class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https:github.comgitleaksgitleaks"
  url "https:github.comgitleaksgitleaksarchiverefstagsv8.19.3.tar.gz"
  sha256 "80b986a3a650fa08b8e864f57b4dffccaa50e6f9623d46a6b7f47c8dbad5da99"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "759c52bc1db42c7379af59056430e971acc432fb554a4efb7f315fd38652dcba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "759c52bc1db42c7379af59056430e971acc432fb554a4efb7f315fd38652dcba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "759c52bc1db42c7379af59056430e971acc432fb554a4efb7f315fd38652dcba"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b04d14cd79c1fb967207186874be02bf2a095d62c1e8d4fe18471e23d71113a"
    sha256 cellar: :any_skip_relocation, ventura:       "2b04d14cd79c1fb967207186874be02bf2a095d62c1e8d4fe18471e23d71113a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83995ae7624f0e23d0d9ba84b57dc1affd2b1a1852292497dbaeb7398c4d62ef"
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