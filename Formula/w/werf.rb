class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.270.tar.gz"
  sha256 "9d5aff7c7e55ffc98863963611a3688cd0f7ccdc8d9bba50656a5c91922d97cc"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c43300b7f063996e8ef21c5224c71f474ad4476391af79ba761fb8396f4a7d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0577e2c1f33f1a4401fb81a5063e265174e6ae922a0d899c9dc1c1ce17ac793"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52162a2ab91b569353f34248790b6907556f394af4b663dffb3a18665d8cae65"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbb1fdc41e67c0616853b11e62934b1abde1461839eee1b6ce5a967b1b80f801"
    sha256 cellar: :any_skip_relocation, ventura:        "79b7fc93137ff4ad4d9017f7bed5ae98549eac32e1e07441e2899e4fdb9e20c0"
    sha256 cellar: :any_skip_relocation, monterey:       "906d3e04016107fd6e666c05333dd63908fdeecfbaf56e19674fedc1e2c745d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "969214d24bdf0aad39c60db21e0ba823911abfd8aaed62b570f41a913c030bb5"
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