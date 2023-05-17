class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.232.tar.gz"
  sha256 "44f5f8c91321fc45855434b4b0899f6551f68cad57587b0651c64ff044fc173d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f8ed7ed87119de707a75690eb68255c4b7ff70f1df806d65b35ba675ccf73b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9b2e8c41ead6d00646eae8e16019bdfb67c3f2d09478d65e840ff825b2c25b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e857926dbe069c9e30916549a4d7eb0c498ba2107c207b748554cfc544ba5370"
    sha256 cellar: :any_skip_relocation, ventura:        "c9c22b3bc700beb27fc0e7752921dcb8d202fdc4d558c15f1ae0ec53a6a9bc9e"
    sha256 cellar: :any_skip_relocation, monterey:       "785135e3a948e4463d6160851096b1fda26117049bb501995bd81498ee9073da"
    sha256 cellar: :any_skip_relocation, big_sur:        "5de68c316cc3cd8a3979aef362aff1eb91712161f8c722fc74fa30b2c3ed035d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e75bbffddc1170f191488c22f4a2bb90f7e48345b7da2d42f8b77a38ea6ab82"
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