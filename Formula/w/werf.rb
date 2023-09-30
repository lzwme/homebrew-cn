class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.263.tar.gz"
  sha256 "c091191b8d516accf8365928c57c550311f5df9a1ea5cf7c14a00f9ba873bec3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35bcafc1734fbfa769e37649d072faba26e2f983d0572811dcac5b503bd31296"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bce4641f70d743d1c6fd17b7550f781647c2ffe0e4715ab821ee50106875b1d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "045805b8d2899d496ed76d751451f7e50662e97e675070c6e0ff02bbc05585e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "305497ff07443e6e26135fc46949bad15c873e13734d3195bff26520874e632e"
    sha256 cellar: :any_skip_relocation, ventura:        "56e47d15c938e0168b489c153fafbe6248659a3f67757b659ec7ee53f9132004"
    sha256 cellar: :any_skip_relocation, monterey:       "bfda3c979e4ef26c9716937f042d9a37ec4e0494b106523a033adc41e4c67a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1109280017a7f513a41ec8d8a7731a178452bf6becdab67834da75b9d34df6f5"
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