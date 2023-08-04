class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.32.3.tar.gz"
  sha256 "2fcd19a8bba8001bd84aa990b7a90dffeea40d871eb0714c9a74a5669acf80f4"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e0364c001f564994d81a4bd4240497a34a097e626f82a7b2c3e1b9ae10f2d32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f631cfe12191ef1bcfd712d144cdebabfe5a99639bd068ba6a3c36619d348b6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "269c2a47f103b941d10609356f1227e654dfb25ad7eb16b3bb13b97d7161ab94"
    sha256 cellar: :any_skip_relocation, ventura:        "37f96e130214d64523d953a02860a010e2fbc3c78ac11fbc20b04e27fd95f18c"
    sha256 cellar: :any_skip_relocation, monterey:       "6f73c78330700643d01d71420fb85d48d568b714dfd1176f27823dfb87d6ab23"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfdcd4e312ff155d23d7be63b9dd2fcc19552383d08f814ca454a4f166bb5c0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f84daf14ef88b5ba61d2c91a1e86713bf8b5e85098ae4610d16c6453cbf2cb66"
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