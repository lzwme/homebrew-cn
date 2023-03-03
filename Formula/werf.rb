class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.205.tar.gz"
  sha256 "08bede54d46f6a600f745e5465aecc7fd96c9c46352c58155542369be3968145"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bee03067d80e8eff7c88934adeba8cdb4760fa8a96b47dec7ea68f2b6e4d7ed9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "841575b63b22ea586c446a9b23c9449ad115496fe8afd321fc31f339ef10aa79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b06906e732f854a47f25e0f97c30d04deef743667fb4cabf21bdbfa6b40a215c"
    sha256 cellar: :any_skip_relocation, ventura:        "4aa6a4930e53cb5634a3df7209f0e64d9f338480de605d56e0b1d60ea436cab0"
    sha256 cellar: :any_skip_relocation, monterey:       "1554222cb8b347ab0191aae57bbcd891b02c1818be87f86f50ecbdcf0731b85e"
    sha256 cellar: :any_skip_relocation, big_sur:        "05411421902861902f240489565895c5e23ba5a006cbe6da01c48f86415a45be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfc0aa03ce8c0ffb9538105d1a64e14816e972f636bfa144e3157ee56c699367"
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