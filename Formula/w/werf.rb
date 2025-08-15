class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.44.1.tar.gz"
  sha256 "79ebd61c01db2dc0a4f38513c78270f24533437466e5276a4b9b96014aafd43e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de93e64d10af3af34d8fdb64a33ade1cb96f4ec58851d88e0527442739206f54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70b940a7ce246edc20d3ca91a0a00eaf31fc7fc8bdcd923157b7591a7365099f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "976c45b7c1b1ada96c3f11cce717aa2fba85cdca76d79985d44cb3ccace82c23"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3edc7416ad827efb30dd2f9cf8cbb369d510b0331009f46da3b01d6acb1eb3a"
    sha256 cellar: :any_skip_relocation, ventura:       "c04d1cdfadad5df82b84e6f110fac80289f0cedb9a392fd60d6e005c21a8ef3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "366f55712a56710b0a359c014443851a6e685f5866c2cdc5939f273f054b0d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d33baecd7837fe73221d3fe18520e95d5a7c755c1afc4e716ffa97a46797106"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/v2/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ]
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~YAML
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
    YAML

    output = <<~YAML
      - image: result
      - image: vote
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output,
                 shell_output("#{bin}/werf config graph").lines.sort.join

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end