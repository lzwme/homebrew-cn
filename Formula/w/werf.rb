class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.13.1.tar.gz"
  sha256 "3cc974d74dba1f58f7f9b6aa4a4f7d3b7edd331cce9ec29e0f26f50d1c25fb9c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a96edeb19afe63b0fb99db87f54ffefdb8cf74213f8c282422468dc04a8a7955"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ddab4b1485d4d403d2e822d8d55215d5953da96966270d0c59ccaf2927a245f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6854cfe4bbc081949c087d0fa125820ea799ed33097f6b2320a3125d865dbf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4772e599a854b9f4e17fba528684be4c924e7e750aa9bb9fb90598991427dca4"
    sha256 cellar: :any_skip_relocation, ventura:       "58d94c75fd43544e7ec23d5f594f7895c0630fa2ccc12dcff4dddc474f712826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c836aa1cec616b6d8b634a0c46f6da21189c636ce9c2ca73b1088024084317f6"
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