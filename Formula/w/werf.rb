class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.36.3.tar.gz"
  sha256 "abf5f2629f471b945de1742c78ce55f81bf5cd741c9d6d44efe6adb5214daf8a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6133a5a1a8005ce089faeba6d70194ade36bd61022e9c6ba00a24bac8c69d5dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33980bf13c6d3fdbb58bb57870216b2356a0b14d8a74f35ae600f8c94d6e431a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f65e5d7d1e89149d59cc3c25cd2b68a354e2339fd6d73c4dbc79624f6c8164b"
    sha256 cellar: :any_skip_relocation, sonoma:        "283e9a206a3221715db08f3bf4cc816447f5ebc89041859442250c203242f9f9"
    sha256 cellar: :any_skip_relocation, ventura:       "96928ce85e4c4c2f309ce44dccd68d7e68ea1101b68b26cd18b411ccd73d37e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "722746cbd312494a39f953f7119040598ead070443d3d4e1b8c5c04038bae452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c664deee13039e9d80ce9e219061fba14494845dec3d3c3b3221a1c71f1e1532"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
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