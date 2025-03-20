class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.32.2.tar.gz"
  sha256 "ce6b745e7c81516f609999ee10cb85e3c9a4842af346af87b53c60730201ccfa"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34126983941a65fa13ee6c81f4582d8a32445acd95cc4e95fde09951193e987b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "874a857561d922a3cd1ff52db5dda6af1d8c14606c912ce3fc463bf6246cd6ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5767aef1d9d4e0522d6695906fd28c6f5b1042e1695f9aa41521fad469eecd28"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d95c733c0a6059b1a4b1513b9b96ddef5d6091130c2edcde6d10f7523342cdd"
    sha256 cellar: :any_skip_relocation, ventura:       "598e89b6ad6ff7c4a44f296ff7a2b835df9e088ae393230240581ce41ddedda5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eb3b3fbd45d6963618c519652af52705f66fca5308bb68be507d60649f7a43e"
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