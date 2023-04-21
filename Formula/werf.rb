class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.225.tar.gz"
  sha256 "1cc26b76bd90d3d0423a57667025061373d3dd6e9f49d1da1afc3e84fa1675a4"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05d288e37c7c27559293bf8ef25125fd48365c31be9649211142a2df34548836"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72307bebd52eee82b0887bbaccaf22b087289529baea0eb1c3f670b67d2f7e1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d25446c1aa89ac15a35794b5dcd425ea0edadd4f0b3bfe7cca141b5afbe7f1f0"
    sha256 cellar: :any_skip_relocation, ventura:        "81e1febf480ae1eb4734ac1145e972909da1be16d55e44cc75d7924af6d7ea2d"
    sha256 cellar: :any_skip_relocation, monterey:       "7f7cec511146dc050bfcb2cce17393a574a765d57e9451c200f0408515790170"
    sha256 cellar: :any_skip_relocation, big_sur:        "57b7b6cc8b68bd6d57ed4cae11d35d38a2fd7b243d55230f996729a246c35661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4a2b59fb8840ed379f849eff833ba433ddeb8cd76d84c20a2aed5bbc50525a1"
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