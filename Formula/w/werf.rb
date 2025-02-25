class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.28.0.tar.gz"
  sha256 "be724fd41a47aa1e16659696e34a3890cc2c2b40024850743f68e80935cfbf65"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ab5ac77e396b68b353b9d69761e71074d90c214fe4a6a5d5e5f48ce6d3f0c4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8773cae5c7191c6d587658bb9c3b8d4f3fc972528c92d7d84f8feb017838dd31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "776140a395e4deb583153b13dc53af83e841d162e57dc47e74f0c66a924b4d25"
    sha256 cellar: :any_skip_relocation, sonoma:        "0328605bc5f0a5e5b13605e2735e0de4a1f5cdfb27790cbcebbfad57d9c237d0"
    sha256 cellar: :any_skip_relocation, ventura:       "5fa72c255f627911e61290bf7a416e6d3d8b8aef057444e18c00fb6dffe888aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c234b19c5eff740484694a11ce09a7fcbe170dd83abe6eade5953a4f5d5b98b"
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