class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.38.0.tar.gz"
  sha256 "76f5ddbe6fbed5e21062a3cc60aa90df2978170736d807418739dbd88c9981e6"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1667dd25fcf262d282b5c2a5d75de6805be1a9bd7d84e09caf3b8cb96f1cf647"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51710dcfdbea129ae22449c22c286d46383fef920a88f5b7c2c28c11cb5182aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d34be206aca4f7e47f02b11b002664a22bc70b64d1a965bf081f43654e4cfe63"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcaa895c19ff658329f6ce0427e288a7a7926e7035a8270aaadb9077cd83ada6"
    sha256 cellar: :any_skip_relocation, ventura:        "84b8f2ec5fffcc51ca8b2d92b6da0d4c2f1e6a3b8537b15d800121f52d7ccb4d"
    sha256 cellar: :any_skip_relocation, monterey:       "7e02d3341057eddcbe6154a1572e42cf68964c5fc02ce1ed8b6df8a4faee6355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ef70d1ec370779dad39a8190e3575975ad0fd5cc645ca8bff70894940cbb66c"
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