class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.247.tar.gz"
  sha256 "3b01c2f79a9966183d443d936e921c9272b340ff6ab1b2992788b6757201a402"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16291d3753c99d5b5ddb331e87fafe45b18e252a0f948a84e27b3795f427abe4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82dfcc817e55546e9f8884a19d039a49f41c7d47623bed9c0a63275193e30445"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "829be623eeb09720c49cc0d9157f587679f19388d7dd8d5ad7030d1084bc90c5"
    sha256 cellar: :any_skip_relocation, ventura:        "cbdcc44d753ce7a467a92e698396ab8d2ac39433aec07edd719c969d05197172"
    sha256 cellar: :any_skip_relocation, monterey:       "66b91c1ad32752ae5a6276275607b9f4d21258db3be7d4904ab73d9a049458d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "442cd87d85f37dd74081102d3be109f278ea4e6d4e115054c48ecabc2e132650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef127e1815e81c134108cefe52a4f928f578c47cd5f97ab7b290434cb95557e7"
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