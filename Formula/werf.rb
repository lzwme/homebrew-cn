class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.229.tar.gz"
  sha256 "3a8016c97ef466161cb9de67bc88742e96c2ece56a398b351aa9cad04fa00ea9"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae273ee2fd4f874c7a89320e5553265f1fb56f1f707542da7005fe4da53cb007"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54a4953b2a96bd9e11a61e597e5157c7557e8c41fbddea7cf9ac080a7600a6cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c08e978e844e41698ad1d6a1ebe431e708f5128670d7791b543d5630c4477403"
    sha256 cellar: :any_skip_relocation, ventura:        "ed5dcbbd07f17823c937d2f20a3047a699282c3be56a2fed524a0be949515f39"
    sha256 cellar: :any_skip_relocation, monterey:       "a30f8ba420d7a09afb072cf11a59efd42c364c08bd0af2a707a8573f2db3d66a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e150b01d0d5056121d908f3111edce548ded15ef565cdfd049d940e9744c2134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a32c631544997c7aa1c55e350cd3bfb132a2c7a79a7cf2d74e7a23b48869b8d8"
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