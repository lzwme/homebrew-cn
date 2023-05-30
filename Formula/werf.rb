class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.239.tar.gz"
  sha256 "1de6726da27ce19ee384bb9b0bafa54603c0b50cb3db263ece712e1e61032fca"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9211e7cc8a8ef7a8c95fce04ed7d564abbd8f440057b8229326c48c958516dff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f650664529ef4b58c2ea9d76c1894e85118d4ce8471304516435b656095755d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eb8aa705647103f6a8b7efbc27a03c2852acb21a4bff5acccd8e06a3933ad52"
    sha256 cellar: :any_skip_relocation, ventura:        "d1dea18eb88b5ea02d2297bd731d021af1976a5b7a42776535e1629b568cad8a"
    sha256 cellar: :any_skip_relocation, monterey:       "f5d031f9964645c88864059dd7330cfcf474aac939a494fc1cc34e082bbb2e90"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba7fca0a949e8c7f021458a81aab126c0d1b1d961300b027ee16af1a05aa1499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c5d927d81317d8f0e8c66e53f5b1967f558d392d388d13dae7cf949a0ad7623"
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