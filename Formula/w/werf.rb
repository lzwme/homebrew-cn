class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.79.2.tar.gz"
  sha256 "57dc26b59ac46f092b8dd59c3a1af174c9bd1f574d7f5d8ef335456fd6fa853e"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f259479ce7fd097ebd75d11a2768bb10dac8045a4c7ed3addf0e56027e7ec034"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7467f478295be2d701ee9b536ae39d5d8cb96845dfa99818621f50ca9c95b8b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1b7a30aad6a4b6ad80df5fff7cce8c4136c75cef03497e5432c94bf43d6804ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eb1d144b09eceed59e1838ae42baf3172e6cef04504296e9c1d54a3e19d29b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "95963dcc29cd7d129869d253eeb54a37c9f31cc60e6cc9e6508edca29ae12ef7"
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