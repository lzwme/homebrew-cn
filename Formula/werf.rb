class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.249.tar.gz"
  sha256 "26e89f2d69313a3eda03964e9baae069705c6df0b91399d9b52198f45313ec0c"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "feb302781a378f4500c80a68fe4fd88b9e5fb4e3421222f9756c01efdd43d585"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b337528a226fe9baf2cb48874314bf3fbd3c13d679ab1ce6b1dcf8d5637f980"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c8c560f5dc9348672012251b2bf269d617e90af371d3ed725e6290b7be80173"
    sha256 cellar: :any_skip_relocation, ventura:        "aebb0fd9e7a6143c5fe2ee33b7d5aa3d935ec89ca2528cf1491d45e954deb928"
    sha256 cellar: :any_skip_relocation, monterey:       "235490bebcdba51fc2f3d8455511dda9031ebd294b2d24b6a0eeadf3f397254d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0cd12d078a3c69fba283f51b19dba29ad5129e1f2fec303ca7582eb79932012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81588b619ea1fe225184fb3c3f4535c61285718d6646d7aaba5aef7c87754cc5"
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