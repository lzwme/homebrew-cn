class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://ghproxy.com/https://github.com/onflow/cadence/archive/v0.39.6.tar.gz"
  sha256 "311d42f8a062c029a747485e33041976fb07c719a004e76aaea0788f5bb16cd0"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30eb668c70cb60f2bcab65a1fc9210ba4eb6cdf79cba920a845000d5d3d20bab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30eb668c70cb60f2bcab65a1fc9210ba4eb6cdf79cba920a845000d5d3d20bab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30eb668c70cb60f2bcab65a1fc9210ba4eb6cdf79cba920a845000d5d3d20bab"
    sha256 cellar: :any_skip_relocation, ventura:        "1940e5995013465a95b18b7ac6d221192bea23873a48927099bc422ad3f47087"
    sha256 cellar: :any_skip_relocation, monterey:       "1940e5995013465a95b18b7ac6d221192bea23873a48927099bc422ad3f47087"
    sha256 cellar: :any_skip_relocation, big_sur:        "1940e5995013465a95b18b7ac6d221192bea23873a48927099bc422ad3f47087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47422772dafe42297536092736d984414c70e95485b6f4fe52fb33c00205eac4"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end