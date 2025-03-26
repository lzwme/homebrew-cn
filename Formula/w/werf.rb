class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.34.0.tar.gz"
  sha256 "d5bed835235b4ea61cad6e39042414fd4cabde258734d744d3ab2ef28220498a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13ebaad728c602831412d244199dcd1d81eae05b511e4b7182da269a5420209f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f166f4870dafcdb4236b9f17a2bcf5da2b300f1a23882379ec1198ca034eaa8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aef6ac408925493ebb6530677a3c00fe82fd18788b721668760861691005cb31"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b549cd7ca3cabe71878fb47e467df26c5227830944411eb8ac3b2f051f42007"
    sha256 cellar: :any_skip_relocation, ventura:       "14e0844b0d6a59c5e4c16fd1ae8e675614c90b2350c37a1bd608618bdc273acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe668ac5b0238dbb8cb35d1bd5ffcb3c4604d003973881b989c1a1e16f0fc4aa"
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