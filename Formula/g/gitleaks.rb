class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https:gitleaks.io"
  url "https:github.comgitleaksgitleaksarchiverefstagsv8.24.2.tar.gz"
  sha256 "b6fd2641657de6349c7c5d36c658f6ba79305cfc5c0614a5fd5232c699a0753f"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b61ccc21bf8caa9bd2f301e88a4f848f3eaad9d397210ae31d84bb357b5807d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b61ccc21bf8caa9bd2f301e88a4f848f3eaad9d397210ae31d84bb357b5807d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b61ccc21bf8caa9bd2f301e88a4f848f3eaad9d397210ae31d84bb357b5807d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a03614f57f7f225fad12bafed308019e334d6efa5c407c016c5bef3da09ce89"
    sha256 cellar: :any_skip_relocation, ventura:       "2a03614f57f7f225fad12bafed308019e334d6efa5c407c016c5bef3da09ce89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "574e9bd5b2aefb558c5ad8aeb678b9e1fae7871dc2e213f55bebcc0bef99ad5a"
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