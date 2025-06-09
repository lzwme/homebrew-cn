class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https:gitleaks.io"
  url "https:github.comgitleaksgitleaksarchiverefstagsv8.27.1.tar.gz"
  sha256 "5f6ff5bfa50f64dc784318b4aaff18c3d1a7656b12b0e77e5977f7a4eecc5def"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a58beafd555a957e6a87c011b1e4ed75ccce0a8ec0dd6b7718ff5e9760d2902"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a58beafd555a957e6a87c011b1e4ed75ccce0a8ec0dd6b7718ff5e9760d2902"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a58beafd555a957e6a87c011b1e4ed75ccce0a8ec0dd6b7718ff5e9760d2902"
    sha256 cellar: :any_skip_relocation, sonoma:        "16b4ad60bda7a3db2f8e1cf10453817ede2c7170ee8ddc37fa44f4e94bdc28f4"
    sha256 cellar: :any_skip_relocation, ventura:       "16b4ad60bda7a3db2f8e1cf10453817ede2c7170ee8ddc37fa44f4e94bdc28f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c2a0d3326194c8e5b5015ecac89c1226f305fb406a724b5cd89ee6c1ef049e2"
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