class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https:github.comgitleaksgitleaks"
  url "https:github.comgitleaksgitleaksarchiverefstagsv8.23.0.tar.gz"
  sha256 "368067da5d8657fe673765043fe0602a66e4b6057fe88baeb41db4fbf62df27c"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54ce122d426c542381aa7f3dc25915353c48ff3d26e1797461ca817a36d2780e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54ce122d426c542381aa7f3dc25915353c48ff3d26e1797461ca817a36d2780e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54ce122d426c542381aa7f3dc25915353c48ff3d26e1797461ca817a36d2780e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6e8dc3596269357baab3e3f37fee8ef7ed6180188eaded82de150be732d71ff"
    sha256 cellar: :any_skip_relocation, ventura:       "d6e8dc3596269357baab3e3f37fee8ef7ed6180188eaded82de150be732d71ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d3a3a10473bd39ed1d1c8a3c5337485a92457c1584b028a5785ad26a23dcf7c"
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