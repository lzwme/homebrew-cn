class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.70.0.tar.gz"
  sha256 "89a4886816a047867f8ac79eac25d760525ddd1e515859f9c9f70ce2f3c92959"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e159f6ad7c974d4a7969a9ebf919d4c91f2479d01907a21ad744bbbd15dcd3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b00c98e7f8ec83334d66969983f03a7bb8b3a607207151d07be3c1c5132908cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6daa58940e468016d4bb245206592e565b5f7dd3d6727faf7cb6648ae631e164"
    sha256 cellar: :any_skip_relocation, sonoma:        "19fa514efc45afc97c8f61b5d4e64fd6d990b30ba50ef092d35a18e064797eb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd9e081f2c867346626105ba0ddda98e9a5d691b7ca67a68dd8442e37bb5ea66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b42cb7216fcbae179cde72259095e7c8d51050e5ed1f03ce262bc775829a87e"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "btrfs-progs" => :build
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}]
    tags = %w[dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp]
    if OS.linux?
      ldflags += %w[-linkmode external -extldflags=-static]
      tags += %w[osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build]
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