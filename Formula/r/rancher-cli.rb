class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://ghfast.top/https://github.com/rancher/cli/archive/refs/tags/v2.11.3.tar.gz"
  sha256 "f165f6f743105359b7ebc0de2fd2428e559f83beeb368aacca202328899e8903"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5491ef2c11b35a82d03b8efaf4118303548d1323f7d837aca487170206ac6054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5491ef2c11b35a82d03b8efaf4118303548d1323f7d837aca487170206ac6054"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5491ef2c11b35a82d03b8efaf4118303548d1323f7d837aca487170206ac6054"
    sha256 cellar: :any_skip_relocation, sonoma:        "66b47984677f8967f474bab6cd15013421312d1552f0e2c711f8fb52041ba9c6"
    sha256 cellar: :any_skip_relocation, ventura:       "66b47984677f8967f474bab6cd15013421312d1552f0e2c711f8fb52041ba9c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4971d49991820bb0aff72028b60fc15cd2a040d672d1fbbb5778b77e8ce244b7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin/"rancher")
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end