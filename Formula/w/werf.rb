class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.35.0.tar.gz"
  sha256 "0878f589ab8f1db8cf43dab28890d3d5bf809a2a8d0bb939f91b4eb58b6ecf2c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bea403645fc3315e1687229ca65cead357923ad6f2ba4e9be4f6000ef03dc489"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e001c57277ca59502c46487d25cbb2607692558c870514fdd0a6fbe982827d7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "861358d01a366176ac1b945fcc55d5f69ef2900181fd0467595f2a06fe94a346"
    sha256 cellar: :any_skip_relocation, sonoma:        "52be3d027b44327e954993b56445a2a33c1d7902192f28e018af5d71bcb05273"
    sha256 cellar: :any_skip_relocation, ventura:       "e59fe8b994133e008da4054bf7041861a720e7c2844eda10004ab95667846c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8768e8a0ec1f9f83258da91e39e55ed0699c2ce7742acc96a1282e3f665a9cf"
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