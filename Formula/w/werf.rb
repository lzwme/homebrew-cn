class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.25.1.tar.gz"
  sha256 "84c7db2b233789b4a6823e8e5817d813e568284dc168d4b4d0cc0769e9fe0c49"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c639e8571af6b3babaa61ab8063fcdd463e22c5506ae422ae85663c399d775"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da1e7d5cd3f6c4f1a1f380b70a1ec9af7a8d13bb9eb874961551cdc7d804edf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b903ad889e3b1b9f5c8e94710f049d731caf406edc264414672b9134f2bb0262"
    sha256 cellar: :any_skip_relocation, sonoma:        "603c503de8f5bdc6471315ae8f59d26ba48667963fa78573dbf606aeb9c7735b"
    sha256 cellar: :any_skip_relocation, ventura:       "f60ad3bbb5e88afd622f67821ace4b977a5819c3c28a774df61a751ded3175d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bf745a386a2109bcf7cbeaace0db23a60239fb12a5a6d7e551cde8efefe8314"
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