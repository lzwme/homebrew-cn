class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.219.tar.gz"
  sha256 "cc9c26e9ce0f7ca87eba5ca546f09337f077e42c8ff442f0376e963de7898760"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "900aff7679592ea893383d5bb7dba3d4cd69de2e245dc2cc755719bdd5b0fc7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fcefa19be9e8e4cb6282c669cc366d7adc1c9367223397077d2650e768d86a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dc414b5f6b97dc425ba3a295cf60b96d14a7c1feda8a593b4c6c13c08c45a05"
    sha256 cellar: :any_skip_relocation, ventura:        "19d70f8161619d99aaad58517180423961e90da65944cdfba16d060f91e962bd"
    sha256 cellar: :any_skip_relocation, monterey:       "da0ef67821a4eb76ea7ed865a9f1118d55051718fc00051c248398c975c07fe1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1338a111ce2a7a55343895cad3521433989ee6d2c77ee266f863aa6acbb9cfdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4be43e670c1a7cff76089be1b5d2f142009d79abaeb61092fa210d242e25842e"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~EOS
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
    EOS

    output = <<~EOS
      - image: vote
      - image: result
      - image: worker
    EOS

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end