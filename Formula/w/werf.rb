class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.77.2.tar.gz"
  sha256 "558739c98c40bf4fdeae54ad18fe7b5d012908390105dd57465b6928d28fe21a"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fee9c7eb686c5fe9c442b48680e74a42764ce7b140d4b8898ff5b7eb160749ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1727c51fafe498722b2d6ea3b22c6db718f273d94133cabf7ec6846b7d10c585"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76f540ea78d6da014071be1deba3f5628ebe76a3faa48b484fb0f153fe271eb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "82ddc78c53c9fc55f1f897c85ccbe92ecaa48a4ea8a281a4d74cc2bef27aaf7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "17c5e71ed47f71ce02535fc620883c5ab7d4bb903d1cfacc6e94f7df608be6eb"
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