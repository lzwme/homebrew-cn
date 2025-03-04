class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.31.0.tar.gz"
  sha256 "b4344c0062ca9e7f08b29592b47eb4b4bc820c5b8e12dd737a2c57872707dab7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb836bb3f4cc9199b733456cde9b8ac9e1d6fd58798841f02fc73e838ec9fc13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3ecf914044695cfbadf335aef8ffc7faa8466aebc73acfcffdb877bb6ea1171"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8dcaf1ddb015a9861226cbefbf65b73e799664ec0d286572148465e5e76ad1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a426d0a3dfe37ce7683ddb9da92a3f09d04177ba6a47ac1a7c3b5151344c48f9"
    sha256 cellar: :any_skip_relocation, ventura:       "77b8f74ca3dd40efca7638b59216ac99b63eea4cb6e5633b8d279f6f85c0a39f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e70ad05c7ad0e742895ddc9612f238edf8c20999b2829e858b691eb7632357d"
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