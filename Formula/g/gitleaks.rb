class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https:github.comgitleaksgitleaks"
  url "https:github.comgitleaksgitleaksarchiverefstagsv8.21.2.tar.gz"
  sha256 "6ce65414c8f7d5a8871710fcd8ff7300dfe6f74f61db560d53cb09949baa36c1"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62112f24e46fe80373ec6e25579d4ae90779c206db60c531d19bcc375a720e5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62112f24e46fe80373ec6e25579d4ae90779c206db60c531d19bcc375a720e5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62112f24e46fe80373ec6e25579d4ae90779c206db60c531d19bcc375a720e5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a31cc31c476da2ce3723237b449a0bda931bf801b5ebb1574ff5c05590149477"
    sha256 cellar: :any_skip_relocation, ventura:       "a31cc31c476da2ce3723237b449a0bda931bf801b5ebb1574ff5c05590149477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe6f29a2d060a3cdc2bba1cae223a12a3f1da974fd6d1bd370bb1acc646da17f"
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