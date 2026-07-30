class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.74.0.tar.gz"
  sha256 "426585de05c3f04365b90073f1ca0dde2ef55576dbe1c8f5de5eb8f007a2d2b0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5d782c96f5bf51a2260f359ca14affd361cef2f58bdc7ec78d6db837b5a433f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b62c7d2779db83bca20e9414b3fc0c61268d2235ec89ba1bbeec978351a498d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5607cda1771f2e832248b010de737c93953cf93b9107c7001b8a5d38531a551"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2466d9f2efe35280f6a0112d75734244dea23849ffed65558e8c4a9de4c441b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f1d86c1de937c224cbdb527a9c651802c22eee719e9f0d6b2ba529eb96ff9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "845adf0319ab5af79eec2e2979fc6a410036bdf33c951c510ed136f08c2881e4"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "btrfs-progs" => :build
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