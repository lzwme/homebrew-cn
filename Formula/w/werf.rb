class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.73.1.tar.gz"
  sha256 "680874700022eb0e1c73e98415d196dca9dab70654b24e0dd238e0d6b43ac595"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00c49b3fa9f3f729b18f946d44d7c657846c0a5a3b998df9f1e0f58aa79e7ba2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fffbcad3489c9b8f9235e33f0bd2f0570c469f61b037f90ec41834345c4d7ffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b51e8a8b3429a1e52a45dafb108577c2a2feb4d5c090dd21cd4d37bfb1338ee7"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc2111cd53022c9912f6891c6003e2d7f38459cb0f8c3ec7cef43be48d4c2977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "982779b454ceb7543e8736f5aec02d1e77dd9d126f5b05e6bbed496c17a74733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e949e1609a8a90aa615eaf56f32314ec2c909ec2cb0649906dbd0ff4edbf5c9"
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