class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.223.tar.gz"
  sha256 "68597ea79c8e68d4ad1d0e10411101f3d63e115d7b9354ba6c4df26413cc2d39"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "288be225d531ba0f8ec4f4580d89d08ccfe5e80c5a8b099a9ae67b52c8c880a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09cec91953037b9cc0d580d0ef457a5517144bfa9492e546340bb5ccc8492a3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0df6d0e1a52a24de605618e599054cb6c8d6a1756af2367e7eecb34bd7c8efa"
    sha256 cellar: :any_skip_relocation, ventura:        "d1304c9ecbb7f1214d7f3760a80da930f638e7c438c78b74b07f1f923098276b"
    sha256 cellar: :any_skip_relocation, monterey:       "0cc116dec5195be31d696a0750bb9c496399f4845d340b969d192ffb7da25e67"
    sha256 cellar: :any_skip_relocation, big_sur:        "e29bc82ef8a0e0dbf7d8a649bc265750ee2c35a5d10d7ae3f996d696bd9f2aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b9c6614dc30beba71dd5398b2744909fcf6bcccda87ff13755549c054e82e45"
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