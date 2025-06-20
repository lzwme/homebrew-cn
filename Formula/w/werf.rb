class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.38.0.tar.gz"
  sha256 "b6d61cc038fd8ab21261289cd3a1d735926693c88417694a4f8721b077bc65e8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb22f0c6158b18519b0bb6332086519adcf3bc5b3948e78f0a1f2abef80b6fef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "459d00e58f366555a4c52103a619aa2e2f95500725236a7e6bcac4923ee95b0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f2877cc0ba8d5041c668b95f6280ceb67be4640836e40c5c58bb5c3c0a6e221"
    sha256 cellar: :any_skip_relocation, sonoma:        "13b3529ef88a62bb45f61fe13e12c3a20062c2ec868568c679c531dd73e4327c"
    sha256 cellar: :any_skip_relocation, ventura:       "5ac9abececbf0d53a0c6b5ffab02a775d0579a68b6c446931c241de8f7d0b3f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dd7566f233677bc935eb66f8d7b368bfbda8ba713d2ddf6aa4ba232ccfc6099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5cd99d6b019b2b3a6a84e7869a643bff691729b2069b5365036331ad8972307"
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