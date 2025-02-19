class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.27.1.tar.gz"
  sha256 "c4c6915e970ddee7757c445be0085f11355c852e3a5fcada7aeb02496ca593b5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5c77c47b519d4f4aec7ca4f490e6d66816df01895909c6e7ec783c3058865ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3efeb8db7bec8374c4a598bc5508cdc3f748d5e6deb3ed7851c847d28eaea253"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "783b3fc4e0c933fbaedaccf693b3914ee9df1603526d19f5a4fa02e4b1980526"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5276f71935c822aa990bf9a64fdf1ef28ab86f66cdf6c671f56cd5bcd4e03b4"
    sha256 cellar: :any_skip_relocation, ventura:       "1f651f7ae66d62cfa4f3bace9727654b34354e99c62c0c2a5865d080b9ed4d0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d77e4e0f1fba207c85e00609e503d330f8b0b806fd73c7444244e38a14adfbd2"
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