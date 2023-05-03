class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.231.tar.gz"
  sha256 "4fe4f7981e86d72a7781a5d2712e83f77ab7147c069470b6e6598e181b45d778"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd343a842c7aebf84841ad59d6f9b89180e7df60bbe86366c7e22362cb67675e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2001d6fe64eeac7def518af6fd6f0a9cd84252b5d006565a6956e1ea5e52d745"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e61434203b3ce110f5d292f611f415c845605f034b60abaf6215fee755fe5603"
    sha256 cellar: :any_skip_relocation, ventura:        "2c6aaea0c1d46f1dc31304ebac1bb3e51d0341925939ea09daeea74478fb6a3d"
    sha256 cellar: :any_skip_relocation, monterey:       "b35dea59605ed9214ca90c0273ede94719e793ad9e83d07decbbd4f2b259f3f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fc1f6435abb9e2bf2a72191e2b93aef5e9364bff5ba27c5e04dc987a464e279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11e1540f64ab761fd7cc8ed7cd0dd72e53b1865e1f09a7faa5d893f44bf59dce"
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