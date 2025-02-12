class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https:github.comranchercli"
  url "https:github.comranchercliarchiverefstagsv2.10.1.tar.gz"
  sha256 "96c167a96fb62f4177b1b3159a9e00acbbe0bb1bafeb68a52da7341e6487e99d"
  license "Apache-2.0"
  head "https:github.comranchercli.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29c8bad6f2eb8f3b84251616f8b63af406c230bf93a444590e86a2d51f308147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29c8bad6f2eb8f3b84251616f8b63af406c230bf93a444590e86a2d51f308147"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29c8bad6f2eb8f3b84251616f8b63af406c230bf93a444590e86a2d51f308147"
    sha256 cellar: :any_skip_relocation, sonoma:        "a30f84832bd2b4893516e322866195943fd7db9e7d404ba7e18eb979fe03f35d"
    sha256 cellar: :any_skip_relocation, ventura:       "a30f84832bd2b4893516e322866195943fd7db9e7d404ba7e18eb979fe03f35d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "753ec0d4a96594846b6396ad334a74f43f0b954150b391b8042f27e3a2d92218"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin"rancher")
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}rancher login https:127.0.0.1 -t foo 2>&1", 1)
  end
end