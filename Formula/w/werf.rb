class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.19.0.tar.gz"
  sha256 "a36ea2ee8a8c78bf50e07b216b0e3ef0eaf4ddff148ea6a5f8130478abaf604f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad1f534f106d361c627a757c697517b1926cef725ec087c0c850009f4b63b99e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e88e2b9f93d59c58fcadc204029caa54ba08f062b8cf281f7c41beef146b4528"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ee77efca7ebdc5c735039bb64c6af329a3b122c122364b5a7c01fa7b21817b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b62e0a2ea24b340aea300d19dd5809a6374e78414b83512ce345c70f56f51e0"
    sha256 cellar: :any_skip_relocation, ventura:       "8632adbd6fff259ca7dc31eb75096f862ae7add25a3e9f65b1e34332e30a4a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb87b3c64e6725b4658488b3e17a7617f63812ef0c9a32db140768c972d24d4"
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