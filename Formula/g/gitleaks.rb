class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https:github.comgitleaksgitleaks"
  url "https:github.comgitleaksgitleaksarchiverefstagsv8.22.0.tar.gz"
  sha256 "906a3f9d402782a6e356ea3a5c737a0392bc84e860af5cee9ec942c074d771bc"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eabedd26c4661ebf897eecbe2a22b59cc5140eec45e5d181e9483d83d66c189"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eabedd26c4661ebf897eecbe2a22b59cc5140eec45e5d181e9483d83d66c189"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1eabedd26c4661ebf897eecbe2a22b59cc5140eec45e5d181e9483d83d66c189"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab8685e149c69f0c5547a37c0368bf919cba11424815b584e02fa42e82dbad4e"
    sha256 cellar: :any_skip_relocation, ventura:       "ab8685e149c69f0c5547a37c0368bf919cba11424815b584e02fa42e82dbad4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e3374bece27dd5b5e55652a081de2358c4b8739f4084e809f1f89448ab32f47"
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