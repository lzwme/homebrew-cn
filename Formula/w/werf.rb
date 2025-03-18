class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.32.1.tar.gz"
  sha256 "3a5dfb5ab7fd880e459830a5db9b0ca4214ef230cd81d03d0dc28c22aa4e263d"
  license "Apache-2.0"
  head "https:github.comwerfwerf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26d31034e89c4388eeb7cf0c838e3b6f0bf3c91464c32884a31220b886dcb2b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d07d2873bec2fd074b0e72e52741669783d54a61a516c086a6c56e757c765dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b01b80396432e3ba1789d7cd0e3f7dd6f9642249155f88c75fa182087e6b6d9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "275612eb767920b83ffe8c41a550f304c2904726b4b55fd782ae4db0e9186a9a"
    sha256 cellar: :any_skip_relocation, ventura:       "e4449fd4093e173c1473b0e686ab91bff294b0c96c2d50129ec094e381e670f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48580fe54b4c30591a17a7738de62c6c54cd5ad72999574457c4c28622815772"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.comwerfwerfv2pkgwerf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ]
    else
      ldflags = "-s -w -X github.comwerfwerfv2pkgwerf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), ".cmdwerf"

    generate_completions_from_executable(bin"werf", "completion")
  end

  test do
    werf_config = testpath"werf.yaml"
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
      - image: vote
      - image: result
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}werf config graph")

    assert_match version.to_s, shell_output("#{bin}werf version")
  end
end