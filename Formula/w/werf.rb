class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.271.tar.gz"
  sha256 "8f038fc0849b1cabd488b163c89e046324d5e58e68484909828b4d909cb21758"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc9233ee0c80313079d64a27a05875f0ed7202f9308da02f0a6b6f1f09490fc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48760dda09a41bffc3358478d1cb7545d507db0d6e3ed1b3532a4b689e9de53b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "591af7496f8290bb69a9b66436d3b3bc7dda30de558cfb1617253384e1da63bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "248792225953b2d9998c845cb278b160f90cc1563c494de4ea2a4ccd34c9d181"
    sha256 cellar: :any_skip_relocation, ventura:        "f06d6c2a77c00f36b3740c60b1abef787b63f86f048433810e15920ca386432b"
    sha256 cellar: :any_skip_relocation, monterey:       "aeaf10da3f2a2086d1aa7426c34eb1b98ecae266bcefa6f645fd61d634a40928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25cef39a6647d1fbda24485b12fdaa1a25f9aae35a33a9454b8222d934551fc5"
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