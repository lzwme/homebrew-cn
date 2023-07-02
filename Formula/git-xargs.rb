class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://ghproxy.com/https://github.com/gruntwork-io/git-xargs/archive/v0.1.9.tar.gz"
  sha256 "1842ad5cd188d8a043539cc8818a546d89e467369c0699849d56d65fe95564c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3212a9b0018ca78d0e443d1985c07d082b4a95b41b2c3a5cafe7d5e63c48226e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3212a9b0018ca78d0e443d1985c07d082b4a95b41b2c3a5cafe7d5e63c48226e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3212a9b0018ca78d0e443d1985c07d082b4a95b41b2c3a5cafe7d5e63c48226e"
    sha256 cellar: :any_skip_relocation, ventura:        "a1b10533125b8580d384231ab7b93caa51ffbd9a0d4eb6f53689415c5491ba5d"
    sha256 cellar: :any_skip_relocation, monterey:       "a1b10533125b8580d384231ab7b93caa51ffbd9a0d4eb6f53689415c5491ba5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1b10533125b8580d384231ab7b93caa51ffbd9a0d4eb6f53689415c5491ba5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eb1dd7c507c1067beb71429187ce1c53407ceca1f50b1f2e5218d5859d805fa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-xargs --version")

    assert_match "You must export a valid Github personal access token as GITHUB_OAUTH_TOKEN",
                  shell_output("#{bin}/git-xargs --branch-name test-branch" \
                               "--github-org brew-test-org" \
                               "--commit-message 'Create hello-world.txt'" \
                               "touch hello-world.txt 2>&1", 1)
  end
end