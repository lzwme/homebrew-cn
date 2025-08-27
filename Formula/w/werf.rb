class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.47.1.tar.gz"
  sha256 "999db0101c2830a66fa666f38897eb6529998df532e13e70b91120ec702aa375"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bcffb2355f55e9080d402337ff89f6611f8b3dfb619e5f782bcc4379e689d34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf6e0bc2e22514eb2cacd8a880a22555bdea24d7d47a3c23ec0d4c99c707aef9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4798e77a427178941d2a4116b1ce0a3ba0a55703103266c7918f3b75612c6e77"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ffaaec67662361e035e02e988d8f3117d7700eab2682b9879feba1c592e9aec"
    sha256 cellar: :any_skip_relocation, ventura:       "8d7be0e98b66fa5522e481f48d66ba631c3e6a293dea1e53c0dd00ff2917ffbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c83a5c96b63c110d9eedb5b66175c4a5cdc6b8fc363d2acbf3f34678493aadd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e51db6425c3e803bdb1146afd85c7a6912ace22fba3c870d3a33da0e6240327"
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
        -X github.com/werf/werf/v2/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ]
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
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
      - image: result
      - image: vote
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output,
                 shell_output("#{bin}/werf config graph").lines.sort.join

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end