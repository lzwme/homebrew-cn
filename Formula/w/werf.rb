class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.9.3.tar.gz"
  sha256 "d3df71960324132cd0ed84bf72c6b5179ca736fbe167f5e0f74bccfb854a06fd"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ea59a6beace05908399b7764cda61440ad1a1bf154a4417a1ecc5323e775bc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28026ebb882f5839b8f34b05fdd8dbc282bde906dedf39e67e0fda239640421c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f989e1a9c29bc718b1096e4bccbff9c1940078f8dfcb6a4c13db752adb23ddc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "911cd5d173985debe022dcd789c8104a6d0dcd262acb5e82e6d6db765a23c8ff"
    sha256 cellar: :any_skip_relocation, ventura:        "e97b1a486ec438033374e652b69f4ec8f1ecd25119bfa51e6864c5b7683f26ee"
    sha256 cellar: :any_skip_relocation, monterey:       "6c60877da54a0923dfd1f2ff037e4833f1f719e05c1663b7bc3f00a712eb4748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd6486e7374c7cf646c324f5a1aa8802ceb0a4e407464472efbb948029bed5a0"
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

    assert_equal output, shell_output("#{bin}werf config graph")

    assert_match version.to_s, shell_output("#{bin}werf version")
  end
end