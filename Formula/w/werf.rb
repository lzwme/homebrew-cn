class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.80.2.tar.gz"
  sha256 "e2e2f90cb2b996d001e291f2f1e8d46be5a236ae9617eb63010059a5811a6cba"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7221b79d7a17755e0f91668f88b7d2bc793b7fc85e3cd364138087378fc12e24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "508d7679e6b1307e9b43d9394ce1b1b6dea138fced4c1fcb5e4b552f5cb22189"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf335967cd1283195eabf451f1e244bc4be262cc511905cd32496f709110f4c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bf8b4349af9014c275adfa1f5253efcdc0950d21e82b56639fe5d84dba121a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "629473de236003afbaf1d690e52419711699705807893a16cbf5447e9c357bc1"
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