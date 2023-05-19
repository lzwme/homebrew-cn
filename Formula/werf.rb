class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.235.tar.gz"
  sha256 "bded48e7aded433d4f900b01957e248008aeb83e21b18802f9eabf39dc0bf6e0"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c37e4f629a184dd3d7b7c23e1f0cf384f56fc14ef7f5ea39f41c1eeff5c6c4f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2329cc1b1a963b89a6696c139408fce421506a5602860bad2b7ba52bc129ce24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "793673e5bd2b81f88be74b2b248976775910c159b3f1f6fe8a05d2c8c1863038"
    sha256 cellar: :any_skip_relocation, ventura:        "a77930ab1943ee828720c3dd1419303e046866f5b0877c593295763c305f62a1"
    sha256 cellar: :any_skip_relocation, monterey:       "0a16d1db19961a6d674aebd15413caddc6a88e136eecab5a06c6691ad3dad1ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "b154bc0aae00749ab6f5afadd6586100dd077fc18aaffe4a196cf65f942030bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37a7f14209d0e8d0e7d2acfd4e4530e15d8b7a14010822b7bd34289235ad0e8d"
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