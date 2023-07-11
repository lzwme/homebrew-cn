class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.243.tar.gz"
  sha256 "d783711681604e43b31dd3c692f0a26b8cc3f467b326f4a6603f15f7c094d81f"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc5127ca09078e637e98046d7194a5371cf9992d8eb90fee6f9eebdcc43cfbf5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6f3d2d694b3f0c853a074363f26e994d3d667cff10b2a48c2671fa06e86cfce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2aef427f9e96b3af08b0878056421f4fbe616f51d880bf28503b14110e475f20"
    sha256 cellar: :any_skip_relocation, ventura:        "def84ba8b6b246072330626449b3517a1160307a93d5eaaf53bab60fe4c4763c"
    sha256 cellar: :any_skip_relocation, monterey:       "6f461e4079b9bb8087064fb586e0ba360fb2a7af79b838950ee97854b4a22c6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d76423430b77718cc18231cd26d5700e45e29f45c47804113599e082f9e4f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1865d15ede2175fc6b6ae97b8c7167c96108ecc25228b0a8f2b7a09cdae3ad90"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~EOS
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
    EOS

    output = <<~EOS
      - image: vote
      - image: result
      - image: worker
    EOS

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end