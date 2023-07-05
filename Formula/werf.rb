class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.242.tar.gz"
  sha256 "d461d0399e6e50859d4ef838ac15010f6289dc99315ed05889a59abdee97ca5b"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e355553ad5b8b74eb5453e0225b8055a6eb7a2cb06efcee3af5a3ceca12d9cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ad7ec42e71c14a67c0c4c070fc01c1e68cd8c22178fbd9df568a3634dd15268"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4316a8ed3a322eff282141900eac35db42eefaa19291954e609699a7f114a89"
    sha256 cellar: :any_skip_relocation, ventura:        "7381915933ea1993b4c933325df6e7ed8247efd3e5405f236b384df281458471"
    sha256 cellar: :any_skip_relocation, monterey:       "3ef7d6980035aa1e800c5cb6d30409763c90d920004a4442e367d953d79cdf7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1bd58c7411d2fe64a3ad56dc6b5805dd5b320d7f3c9b8e2399f9fae9dbba89a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07914544514347b9a69ab7f8600e6390564d0f7437862c2587f1f084b6931981"
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