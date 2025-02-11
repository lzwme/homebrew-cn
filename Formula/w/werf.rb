class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.26.6.tar.gz"
  sha256 "37741088a6f3ba19c9b6645709417d5bb8fe9c62389c7a8369f74f97afb0fb4a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faae6eed4b3a3f84857ca1be662b40ae7260121238eabe9059c7193e99ed824d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7dcc99b5077d2bc3e4a5d565428c2d0c4687367e3fc635d9628c1f27d92474b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6079c048c56a5fe095165727df2a31166628ee8664ac0f696d798a420856795e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b7a69443f0c519b6580b49d7deeb09b3923887cd459f9b6315270ceb0610a9b"
    sha256 cellar: :any_skip_relocation, ventura:       "b0d3a46c4086f173107bd6fb1da16a1acdc0634b1391613524b23143a6ccb5b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a98c6c924a3a4178c7c319919766fe00a7c2af2875454a9c286c653fccf071e8"
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