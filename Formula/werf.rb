class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.221.tar.gz"
  sha256 "cea01e148921058ddff9d4f74ac1f9df60e12422a2519369455e05229ad1b615"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3714f5f2aa1274f1b1880ba6c192baba4575188a26498b8ccd090da3e7049bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0bc95d7783ad071d9046568844303595498c125112dac62a62c8276199f0d8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ed2f7d5b9e73c63a209d8db008de70a37b73f150d358297ba8021529e41d3d0"
    sha256 cellar: :any_skip_relocation, ventura:        "a488e17e1fb7c4a02788f3a52735095e143ccaaaa110df337544ff17f1eb38b0"
    sha256 cellar: :any_skip_relocation, monterey:       "0e30d10b11bcad3b561fb662fa001f1509feff980f448ffdc35eb32d54b06847"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb6109ea6ab62d5cd9591d09e92bded73e6928238bc8cdfa2a92cccbf1b7f310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "243254b5a1f8fa97a27e9537747d24cc6ab0e5f1977e0a7039eeb7a6022f3dbb"
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