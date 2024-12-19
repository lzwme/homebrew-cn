class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.17.0.tar.gz"
  sha256 "cc84a00b21137e972f09c2c7f7133d28f3d1cc80a38b15e50faf34fddf7638d2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "027a486cad3a082ae4c6ec57c2b640f278907fb2254de2b50226ecc069db4300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cd001947d8811fd4cdd57588a694af0458f12238d564a13f52f848a2d678f6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dd013ee52e7596f7cdb2d16bf51b5adab0281059d8f4f45a5c46c50da819695"
    sha256 cellar: :any_skip_relocation, sonoma:        "271f1f0cf7183860567b288d2ec70cd9f98338fb8bf29492e44878e8615e7941"
    sha256 cellar: :any_skip_relocation, ventura:       "49f2ffc3e329deca44a5f4517ef8b19a05f7808eafd6be8cae7c62aaeaab1c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8664cb536b9374f79be350b0e1744d33f9eecb92a69e7d5fa15baae1575118f0"
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