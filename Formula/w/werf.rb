class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.35.5.tar.gz"
  sha256 "5bf0e7f685c41c76a576828682b00bd6bdef423eddc099ac55a1803c510332dc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7a8f0c731708921534654ed5f7a6dbf8546ae3fcc71131e6521d8371c292f76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2306b9163542b07dcec7e263447d454c11630d1582598af4177f7c31f47dd5d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a41509c8773084efab525be7cdbf99b1032cb6596a4f256eeca38a1ecef94758"
    sha256 cellar: :any_skip_relocation, sonoma:        "32f6a3105f139874f7f75670b68671b2b0a2fadd030cdeefd075bc63e705098d"
    sha256 cellar: :any_skip_relocation, ventura:       "cd2c413011f83cb9e5428244669fb9f2444747dc698a50b9904c551e4ff7bbda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6b528dbf72295dc4b39eaa0b45337603a401607bd4d0768fd35942ede1c0787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89e9f10dcc6b236b4b7dbd484fb3f1d983462b6db67eea840e663b74c6f8ac1f"
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