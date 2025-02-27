class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.29.0.tar.gz"
  sha256 "508e288ce294d6d002ac7268e699b7817b9ff37bd37a2111a2a68acf184003dc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c08c13241b327829a7e00b157382e44caaa5d7252a51f3129717b377c5ff94d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fd5af0160cd034d01c26d7d403eb080fbd6eac19c0558fcbd64372ebaf30940"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37ef35dd6ba2659afdca2ee55a19b5028b83c2c28910dc74b3befcf6fbb8253a"
    sha256 cellar: :any_skip_relocation, sonoma:        "622b32cbd7817b474a59f00e342bf78dce841adb438dc24dabad92241d6865b4"
    sha256 cellar: :any_skip_relocation, ventura:       "38959dd6e8066fb88d96f8cdc4cb4f5cda86a84dff93ac6e8adcd087372d4bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "517452c2e878e1b099c0f70c78bb46fe7483adc527db91b29e6223d372fe1357"
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