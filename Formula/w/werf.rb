class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.68.1.tar.gz"
  sha256 "1fccb5e6ab1dcb46de0009e8503710036f01d7ce4f9e39a4f911b706729de9fb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad526688ce28daa27fdc952e816eec1943a30bd317eb1d25b940e325a0e06c84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b898b447783acba803a312312b85b03369c9c3f841c3bbf4758a682bde0b991"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4be2d9a6b5bcb04476c6f709966e4c23273e719b5fc2fc2ff44d117c3f1e8c10"
    sha256 cellar: :any_skip_relocation, sonoma:        "4de3683a0a59412168b7a11d1147c2c12a3f03db9000565d64573b8304392072"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e715d5b2ce629fe9e02fac8a7cc81970a16c943c690e86a9cd8ec40a10b3d2cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b3a64d42fedd71e80219defb7642b35db1a42362481cb76ba8a72538bea83aa"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

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

    generate_completions_from_executable(bin/"werf", shell_parameter_format: :cobra)
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