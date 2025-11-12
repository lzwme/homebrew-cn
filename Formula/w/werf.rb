class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.51.5.tar.gz"
  sha256 "7953cac92bef0977a3ec619d877a62235e714abdfc0b1869599b74cdda21f208"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa97e23f044654ed678638e4dfe0a0a1e28a78841d15e564a5966d43baeb23cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dcd910a014d0b7292b7df5262a4bdab2281705bc9fb4b88fe0a850560a8d483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6753df99c7f4e07521d0d7cb628e0612953707f596164af52b8b7c612e20fa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d87a74b9288e1061442b2e736b2aadbb8e1c8113f959370213531abd7356e3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8e129f6cdf07a667a4ecd1b5eaf43cb20588e7f182cdea04a6f8b3ec830eb07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b1ff761307acdb115b60fed8b2a0e6ce0a71193c6e4f027368e49df3f56881d"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/v2/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ]
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~YAML
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
    YAML

    output = <<~YAML
      - image: result
      - image: vote
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output,
                 shell_output("#{bin}/werf config graph").lines.sort.join

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end