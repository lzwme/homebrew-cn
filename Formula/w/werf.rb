class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.78.2.tar.gz"
  sha256 "cec9599ca209579fe0bc4bd830fe54a6b2810aa4e77b385b59c5ed36b30ee217"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a817d8c802829b57958bee5abef6c4d36ffcb9faba16d850a022d560003c9b8f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "156cad2c63ac36820cf42d281b924d115ea2ffc703cca58547929271d5d5d706"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bae5db29b71cb262f0b1dc2fdf6114aa575335b7fc7e9217982d891e5ebb508"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "48ef5118306bf919b4cf81db6c9bac7cb90fd7cbae67059c1fa2e223f23d2d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "14981c1d79ff15ba1c9c7947e4214bcb7a6aab1e7bc0f784b2df46d26ce471a9"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "btrfs-progs" => :build
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[-X github.com/werf/werf/v2/pkg/werf.Version=#{version}]
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