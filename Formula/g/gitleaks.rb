class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https:github.comgitleaksgitleaks"
  url "https:github.comgitleaksgitleaksarchiverefstagsv8.22.1.tar.gz"
  sha256 "03589ed77e1347ac89f78a33187110c803ad5e4e3e7da6b3e3520dbb910259dd"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85c26ec7071eba0e82a939e1442c6a5675b7a24a0ab675b99c944ec4e5535abf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85c26ec7071eba0e82a939e1442c6a5675b7a24a0ab675b99c944ec4e5535abf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85c26ec7071eba0e82a939e1442c6a5675b7a24a0ab675b99c944ec4e5535abf"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c5b34c4642004f1bafdfad267d0331a829c17b8b1104b8c515b68840a746a64"
    sha256 cellar: :any_skip_relocation, ventura:       "6c5b34c4642004f1bafdfad267d0331a829c17b8b1104b8c515b68840a746a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f790958b8cf5de1670ee1089739d8b6a069651cf0e2bdbd79ee473879243645c"
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