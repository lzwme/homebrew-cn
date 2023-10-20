class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.267.tar.gz"
  sha256 "f60e58a55013523cfc48620c5bf948b300b4d2a6d4b60d23a9d4af266f2f7629"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1ca5f9931b2bf3dddef680bc00ae589680d1d306a5e0c822649b6fbd7d4cf49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3de62ef13990ac53b1d5a96c4ad18d67d9ecf8490f62d2e0ab4e6f90e7cc68ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7d179748f9b9bdba24f776de74f57c3765fc1c1cd46ac8a95a3a75d599c49f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "cbe9cacdc20e156545e115211d9b0e7575e8e784dbb0288144ae8c064bab3860"
    sha256 cellar: :any_skip_relocation, ventura:        "18d67d2de81004bd16cc96348d5c3755cb0ce38dabac4f02a3c68555eb80a4a2"
    sha256 cellar: :any_skip_relocation, monterey:       "23c9d28939b0421df78b341e719a403cd8116d1999ad6af608d2c8ab86d4b6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e882f9890b876ceb25faf663ca238aa5bc0833290599d17c9d05fb5b2ea2d021"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~EOS
      configVersion: 1
      project: quickstart-application
      ---
      image: vote
      dockerfile: Dockerfile
      context: vote
      ---
      image: result
      dockerfile: Dockerfile
      context: result
      ---
      image: worker
      dockerfile: Dockerfile
      context: worker
    EOS

    output = <<~EOS
      - image: vote
      - image: result
      - image: worker
    EOS

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end