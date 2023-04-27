class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.227.tar.gz"
  sha256 "be3c3eb5765d403cc904d0f290bb0aae3e5fd705b558c4eecfc5dadbf11dcd80"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "212af9b17b7023dec1fe95e3b1ef3d4fce0e81ac7f57fcebc71be57215b76815"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbc21de753f91d14421b0387f46cff5655c5555096bf8abc374a16209b381b89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d83b4832ad8fc2edd6034dbf072cacfaecf55cd34d14f3a53f53135c7e326eea"
    sha256 cellar: :any_skip_relocation, ventura:        "6b8b8b242c156ca9a51dad5b8e3f6177709e44ffe7fd81e461ad8bbd83eeb41d"
    sha256 cellar: :any_skip_relocation, monterey:       "7dacd5446d9c17cb1384d4a70fcd30fc7272ee3194bf82fd64eff70d57521c17"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4a6222da038be61630a82255ae3576c77acbda6896c0c4ab6a353666003b407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "655cf3969417bb5bf2dd2479d25adbcc08428067c706bbc4a1bc318eb000a04e"
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