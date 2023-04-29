class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.230.tar.gz"
  sha256 "3c214bdc22180bbae3f31aee4a458d66f685d99374002f32fb551f34df40c1a3"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cde5f49b7e37afcd0e91ba1e5e8f6b8990bc57b946391e9597e58c6e63fa6ea1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33fc64624f116379541380afdc38a07753977b40647c9f22a10e137e657688e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6abd6ed5d6b29ab9e9fad1d615922a3bad0160b5b18c5cb0e11575035d6bb446"
    sha256 cellar: :any_skip_relocation, ventura:        "0dc6c7f60272f775a2cb5b74220cb36735c2979ea6be62a8c003875c248bba9c"
    sha256 cellar: :any_skip_relocation, monterey:       "edc686e48aebe62d75ecd342449e5f0d0254920dfed09656f44eb480ef80eee8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac822d4f3a543e98c1218630860b5045d43470d539e997a0042717c089cce5a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e6e6da3b659d5a56a9bee7883ea3b0608fb731bdcf03b9d701283ac22cac9aa"
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