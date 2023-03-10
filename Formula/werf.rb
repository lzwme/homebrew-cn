class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.207.tar.gz"
  sha256 "1cce5d3323f3efed19066749f05a83d69c99823150d3e5ef2d18d0b499a38595"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de9eb8146e1f11a6c1e61bb5e0295aec1760b5ed39913fdac72e86a04b7e5263"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5ca6f21f2151f3de60aface4f51bc36525f81f2a1e572c0a7942aa6ce26cd38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "062c37ca858b41e945ede6d7bac965bf58cf19c525b5d3032af1cf821048acc4"
    sha256 cellar: :any_skip_relocation, ventura:        "34fdc9d1ab7e37083fae3873f4b854e2ef0cfcb038655b552c2cf2cd82536786"
    sha256 cellar: :any_skip_relocation, monterey:       "e6fc261fa377a6e7aeb85d07d316954999b2fbbcf1d08ddf27a6883c327e51ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8e9acdce78641a514630a5d5cda69e2eabea0961eb54792da5be8cca9d376cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2267bd39960fc5d0aed967fdf83bd4f1f2264717abbe6b002d041a8600bb2867"
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