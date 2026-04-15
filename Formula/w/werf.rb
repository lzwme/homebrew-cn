class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.65.3.tar.gz"
  sha256 "fcd34cc0a5c98ab05cff8177b66608ad720d2748daad21c64d2c49e62fd3759b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61ea977779a3524852121d4a390420658ebe28e8d955d043a4b37ffb0f48a6da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7eb05c18f676a772ed7b826e0d84533915fd1e46b10681c55969fa6855630dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2a0e23de1225fba4aea54dad7305f9c001c538a7020d210d82cdc901483b36e"
    sha256 cellar: :any_skip_relocation, sonoma:        "136e53655800b52847c003f3225f239e844ae71d3d1364e03ef53038e834647b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc038a7778b0e0963de371a1e238dd5ba8963576b8a618b44956250e7c66c576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0ef0a168ad6e95f22db861b3bddd27f670ba80ccaa98a143adb7beb117e24a0"
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