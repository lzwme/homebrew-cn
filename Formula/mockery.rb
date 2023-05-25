class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.28.1.tar.gz"
  sha256 "dbcfd7f7e42c9291466fb6ae7cbe0d87aa2614ca393065c036cecfbfb899d535"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e004e9c30a82c23fc57c7d17d7df28be66179dff2a66ba788fefe114e3e69eac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2af5dca1685a735ae50953df7790038e2142d7e00bbdf20830154791b43c645a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e90a3daf50c43e2eebaaaf473b29cecba8c23e930e12377f4cb36eda51e3e97"
    sha256 cellar: :any_skip_relocation, ventura:        "88a3227e0b3f3ca616d9f5d7894ac00f507e5634ad37205e390c938188c2cea3"
    sha256 cellar: :any_skip_relocation, monterey:       "fd3fbd9aed4c44968306404052c3578c9f7bb015d2f63228ad66dfe09e9ae7fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "70784663ebc1e82900d3416c78311831741c8dc71069244cae9c674d33b3ac09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7331def63c9cd87070cc6fbe72e87b436a662883fe88652b8aedf4e9beddd728"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end