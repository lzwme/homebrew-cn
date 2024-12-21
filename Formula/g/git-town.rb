class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv17.1.1.tar.gz"
  sha256 "26b0f1357b6bc4dc5c53b70c9634895c181f89b3529c62eea1346e247ee74003"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0552963c5da7cc4378ea323b4703ee6824d774f4b78cbeb0d5f551d1c1c8a027"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0552963c5da7cc4378ea323b4703ee6824d774f4b78cbeb0d5f551d1c1c8a027"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0552963c5da7cc4378ea323b4703ee6824d774f4b78cbeb0d5f551d1c1c8a027"
    sha256 cellar: :any_skip_relocation, sonoma:        "91b43f3e35d174ae4b7d02eca011c0052cca6bffff66338a6504294d1e7c3137"
    sha256 cellar: :any_skip_relocation, ventura:       "91b43f3e35d174ae4b7d02eca011c0052cca6bffff66338a6504294d1e7c3137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "464c9639968edc7990f9ea4634165f97d16b63338ca49867f6b6a5debb39447f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgit-towngit-townv#{version.major}srccmd.version=v#{version}
      -X github.comgit-towngit-townv#{version.major}srccmd.buildDate=#{time.strftime("%Y%m%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin"git-town", "config"
  end
end