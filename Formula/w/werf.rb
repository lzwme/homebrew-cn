class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.251.tar.gz"
  sha256 "b2a43333587e6755cb86e6a7fd0f6b2d4024c578d8cb28d9a106e03dcb182ed5"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0fc56e9fc9b0284ed30199d299b810bf0814c96a0cc90fc0c8e1a5cca8f3308"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f94ba541492584885306343d7d2bfc856352121259c652244e11cf47fc382288"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "448d1caa6b896acce0cfb7a5fbc872cd1aadd7377a650fffe61fbed8bffaeba9"
    sha256 cellar: :any_skip_relocation, ventura:        "3130bb7df7c73c126687ab6b20797800b143d4cd9e3141ef65d04b5a592e3e58"
    sha256 cellar: :any_skip_relocation, monterey:       "9e1a6734dbcbf478bb74ea993011eaec06d5605b5e43af5d7b54c0a947a93c8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "881300cb858ff8d96f1f6c7b5551bacaafc5d4fa38d8878abb3724d469fd43ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e26bf89a72d5f18c4374024c6b365bae15b567bb186f68ac5ada76df299f3785"
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