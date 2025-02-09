class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.26.4.tar.gz"
  sha256 "d8638fb9ae04606c07510d5521ed40b47141c1d0e39e76627b77af552fe383b0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b7a087eda964c2c31021d7b0b2c07b389c9c594a33357ddc350c185eea0d43c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbcce7a9a21e458383c73e0371cfe38bc668668f68a2b675aaa60200a456a39a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0066697ac70a5ea60e685c449b4dd5155662c0e6c72be6a1ebb41ea8bbb406e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c59fd1cea071a0ce19e266d1b49a60643380aaf84a4ab93a5832c353d4acfd07"
    sha256 cellar: :any_skip_relocation, ventura:       "0dba8591eb324bbacf772cec1c99d314e56ac52af0ea750b6e0b0745e6905a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf8cfbb7681ab50d546f340f702770b940d035a45bd141bac195815f82e7be5b"
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