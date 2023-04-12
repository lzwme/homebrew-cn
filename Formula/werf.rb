class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.222.tar.gz"
  sha256 "3eaed8abd0c0ebae1af62750dd168b6ab0474c1c61b78b599cc4c83cbe392a35"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16f8a821efe27113888cd0e6ebacfaae2f314fc69bb229f734cda0497c7ca636"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07d2f16977f6f7deeeb09615ad0be18cdf7fc61810beaf723e42c2265802f3a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "681d70f5658a4c86a0f871487bc52d015c132c7b74aedd52b7836f1092640425"
    sha256 cellar: :any_skip_relocation, ventura:        "5ed29274f544c5a9f0d3a36b58ea8ae07aac275ff655b96be5c8a48acb44ce4f"
    sha256 cellar: :any_skip_relocation, monterey:       "1c5a259eaec9b91d43e97bfb9da09219b3562917805cc461ed9e654c12ce56e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "708919f405acf4309f364ac5c0e2002020540eabe8043293f623371af8a05254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b1c50904e2994d5b80d4992123b8122f735f77e03b992f694ea565fa871c863"
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