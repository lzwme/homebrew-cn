class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.26.2.tar.gz"
  sha256 "da8ae256ef30beba8bbadc954c6eb02c62b7d52776b17f08f1d94ed8afc32a10"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ce6a5fdae12a41c5c5a8a8631bc4653b0250f56b96e6af47df583373de3b750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a72b75013556efe1ab2db651db828559d19a27ebdd4dc394350214cc2e68fee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24c96528221d4e5d155404035a2e8d5867380d80327431439d4af24c7ff6a947"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b3a443f0e676e78f94f352950f6d51013c2beabf92d9fca281260e1857032c5"
    sha256 cellar: :any_skip_relocation, ventura:       "c15dd51e44e675dd043ada1462d94b487027e9af3d6b432fa925310e190111a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3a976df77d995dd48281b4f936ccf388dc1a8e760ed86457515526040bb0e70"
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