class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.256.tar.gz"
  sha256 "c7188128daf7b28a260184ef1f18abd52a1c80aa0347f193b13510736142aba8"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e750cf354fa9bb51fbaadf4143844f8f0338535ecd3d48eb36976bea1cceebf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9810ab7b14dc008e4c1a7ed15f1bda447a2b9711c627fac7de25599e49c89549"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdab45189f781a20eb5c53f62a3c1949f6ca1203dab19d931f658241b3ec62f3"
    sha256 cellar: :any_skip_relocation, ventura:        "0e38c38eb9de578c04bec7baee1e9184f34d0e43a22e6d0dcd95200f198ed32e"
    sha256 cellar: :any_skip_relocation, monterey:       "042849035788fac7c8742b3c5fe7405036794e6e5ab5fcce546e7639e35e3409"
    sha256 cellar: :any_skip_relocation, big_sur:        "45dbd117f47b47f21328c02c40b48af879a8eb51179978564ef8c4ac19ac0928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "079194e0ee545168dc13b6f3a655287bb7e3e1795bf6964de612a2c4193f8fe4"
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