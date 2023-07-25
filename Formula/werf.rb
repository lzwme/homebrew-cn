class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.248.tar.gz"
  sha256 "a1f5f0da6267ab8aca8efb8098bc558b35959274ddcb81fc7c7071bdec7a47f7"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1aed8a911f2f5b89f09d3f0f0ec62b52af47a9e5938fc335eabb9f8ce371d2f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "421a29274ec9d8c7f90a01717c3894d2a05dc806e82f930b159ec7d4a53bcb24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa7bba896317ae4f7c02feac7e5702c26cb557fbc269766f5173708877653004"
    sha256 cellar: :any_skip_relocation, ventura:        "b81b9f64bec7e7ad560426a2cdd88318e5287e7e76be47104060cdf81d753fa7"
    sha256 cellar: :any_skip_relocation, monterey:       "b96466b949cf9387752e6d1588ab5a5dd0da44de752acca69ba6784c77e7cbc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a05c571b51c55a3bd22637587a1f7a5614dea79fbc5a06ffc630a8ebac0f7232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56488866ff0191539bd850e90396e3a079c473b7efa5f85df03344ded4974f8f"
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