class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.68.2.tar.gz"
  sha256 "eafaffda35843e9407a7db71ce9bf2a6ecc79bfc3193765cbf6a67b6f3b47d98"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f3e62001a1920a8a99bed1661af1fe90a899b815221f887a653bec56ad7fe61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c57458278fd44f3854322e19943afedbeb46e864080858fbd77c187c1dfe8da8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ae2386fd79e3d0292770deb19e76a349f46b1817ee3f1d77b82463b0b74c9c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd1ea3fdea008966d287c4ec82a2da214aa003c28aa7a0f239e735204dcae050"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76576eb8f728c9eb9b0ff40a44d45d8463436fee30f5570da623fc85ee6dfcab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91236ebc11a0601249199806240165e27ac0cc518d241d2b315389d660afc56f"
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