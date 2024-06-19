class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.6.1.tar.gz"
  sha256 "c6f3636fb6f0d094fa6f253c2fc21d6070b4e7b015b7e1c2a9da686e99247b8f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65e06e70aceac02e900a65a000943bc41acb6f12a789a1de97194df6e686d025"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "717a6e753521d3bbc808f03ccf1f5d073e8f5ff226b916ce8d556a3f7b33bdaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c2bcfb6a92fc196b6720b84318ccf97e7ae6cc1908ad1c2b00181c8474a5c4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a4a61b0d4b76c7599ad63440def7c99aae3200c2bc44ecfb1f598cb9ba3d036"
    sha256 cellar: :any_skip_relocation, ventura:        "34604241ded0afca520567551e2a21b394640fc625e15dc8dc8d48f0d1de1785"
    sha256 cellar: :any_skip_relocation, monterey:       "e2ebeef3d83a9e18e38d58a43dee1c939cfbcf3dab8d307794718086b902dae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "843e49db89e776ea388d2eb604bd35b9faba49c454cf572b3ce2eb81cecdc3d0"
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
        -X github.comwerfwerfv2pkgwerf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.comwerfwerfv2pkgwerf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:), "-tags", tags, ".cmdwerf"

    generate_completions_from_executable(bin"werf", "completion")
  end

  test do
    werf_config = testpath"werf.yaml"
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

    assert_equal output, shell_output("#{bin}werf config graph")

    assert_match version.to_s, shell_output("#{bin}werf version")
  end
end