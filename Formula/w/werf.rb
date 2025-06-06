class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.37.1.tar.gz"
  sha256 "44dc105ff3faa5121217dcdf3d1e4dccd7285357f1a0f5eed610b817d6d01c6f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cac72e78a8ce2d07de7b612e3b5b6b31aa96296e47fb3fb975f49b5f5b1eac1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbca9ff7aef1d422abc2a07dea8b02316b3a7723799625c2f094081afcdcb7d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39c2a12b22e9e6f61807c6977b55236131863dab41d90244cf30b4c9ad66fc55"
    sha256 cellar: :any_skip_relocation, sonoma:        "e83f37c2ff00ec044cb94e9bf7987e37ffa1f99e8b7360f2dd94f6c5bfad6f56"
    sha256 cellar: :any_skip_relocation, ventura:       "9ebdc1b06ad4038380f25f96cf3ec3613dc9485b44c7e3f667fbbd2d3c22751a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe7fe2e865ad88f6cc94d6659d149124e59f418502f8ef8dc2de24790d4fd6c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "220ff0484f1900edb67984738189befedb9dd9bf93437bd1ea73e97f242f75b6"
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