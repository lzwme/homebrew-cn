class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.56.2.tar.gz"
  sha256 "40af139c53755876367508ba4ebe8376c6d85dee59784554496944dc60ae45c8"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b70ed6f7f87a0390b0d1b71b2659f045d4572c606634259412215942db7a8f3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1357b6729c6641382b856c187cd3ab8ce712dcdca3cdea42a16d3ef38791d5ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78b0553c5827204850c6e53836d7d82395ff24e552f2a1707f8a3bd133d14c5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bf3fc0c84a9d6b1519436cbef14feb3cd357ecc831f4cf4d8c792cdb64ee0d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "326030ba158938a51886fae3c976cb7f0f98279f21cd6cd349f957fab127e554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d37c99cf5720fa9b3e003647e2677ca5d7cc0cc15959501d49cafcf323599726"
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