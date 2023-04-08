class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghproxy.com/https://github.com/kumahq/kuma/archive/2.1.2.tar.gz"
  sha256 "1e0e834b3f20142c3e99971c45d50e80de4bea3fa5e9ddf2e586a38ef7e17d01"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6406f57878330b59f78611675e2e8408bbb741ac21dc41575c515f6ccf031984"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6406f57878330b59f78611675e2e8408bbb741ac21dc41575c515f6ccf031984"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce214ed81f5a5e3545c63e024fede6f86784193107f13c69a259538631f1a4a5"
    sha256 cellar: :any_skip_relocation, ventura:        "de0b44564ecc4828e1d1155c5e732babd371133e3d2998df4e04b735c923c88d"
    sha256 cellar: :any_skip_relocation, monterey:       "de0b44564ecc4828e1d1155c5e732babd371133e3d2998df4e04b735c923c88d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b2a24c762597f43ac42a7901c67c70eeaa4f29e3d4e9757e841f7e6e2a5bb5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "792c2c9b5cdbc5f49653e0401296fd5854b4ebff058d6ef6e3db8b49ee538c52"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end