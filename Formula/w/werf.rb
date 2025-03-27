class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.34.1.tar.gz"
  sha256 "5dea0c61ff8f9d88e3facb0d26d087c49860b0da973c38383137ac3daefbdcae"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a6876be42126459d82a445bed90d74c86a6e7afae217de07c347b0e64c030b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "248f47557a4d7e3ceb596da157c1cd31da2e44ac9632f1b6d48c550791a62f98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0910e91161a90aafe2738b2e733dad3726c9a8b2a584e30746102c2ae8280ef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d301ef296ff9bffdd84006516a7f56f3ca69bf91223d160effbb397a6f78b3d"
    sha256 cellar: :any_skip_relocation, ventura:       "4fe2c6f8facce5ab83a6e759d1647f3e6b83c080648f807c1456e8361feb3f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51b631cd63273bf0c2073aa35fa41a808177438485357e2df1392951ba012538"
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