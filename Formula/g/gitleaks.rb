class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https:gitleaks.io"
  url "https:github.comgitleaksgitleaksarchiverefstagsv8.24.0.tar.gz"
  sha256 "a0c1e7c3b5d0ee621f1e48b3d502132f8a3e20f9ac2ce3f450c6fca55c702038"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02a18ba61b96ac979833ab9be8bf880e748a0e1b7dae8c2d92e1a96d2da8d699"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02a18ba61b96ac979833ab9be8bf880e748a0e1b7dae8c2d92e1a96d2da8d699"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02a18ba61b96ac979833ab9be8bf880e748a0e1b7dae8c2d92e1a96d2da8d699"
    sha256 cellar: :any_skip_relocation, sonoma:        "4997c84dd411d6d1c16d01974e45130c6713b891f5e050444e7ecf852d05d5a4"
    sha256 cellar: :any_skip_relocation, ventura:       "4997c84dd411d6d1c16d01974e45130c6713b891f5e050444e7ecf852d05d5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81b529c5b03a7338274b89f6de4a2ea807f12796d41f6495bc2b5148b318d849"
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