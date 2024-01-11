class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv1.2.278.tar.gz"
  sha256 "6a81f8931b4a29669f2e2f8526dffe0662416652d3ae60591f6a6aa451c8d0c4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36bbaf7c8e1a79888a0eddd97e48369058ec364eeeef3f6b2ba3f68152b8a6ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c39a799954dac2cb5d2cf3a0f6815ca382c2898a583b762a46879f0df8837ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c64da226c16525751a72c3a9541bec38aaf110f11e754ee1acb5fb816a3a30cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "104e97fb69a65c92044a7f4866f643af544860671e73a3794191f5c41f2d1f92"
    sha256 cellar: :any_skip_relocation, ventura:        "a04f2c3c469f291283ba104087c56590198034c0ff5bd2b7fbf71789feaf8c1a"
    sha256 cellar: :any_skip_relocation, monterey:       "4785449acf1b87b0f24e54a4d7d0234dbd04c4618a4834bb757b14604a303f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73d8726465358d2629ee7d1aced17af49920020e2377918231b1f6e8f053440e"
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
        -X github.comwerfwerfpkgwerf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.comwerfwerfpkgwerf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, ".cmdwerf"

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