class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.36.1.tar.gz"
  sha256 "dc2ee9a8deeef122de69129b39d520cabbfff0c9c721db04c7f9f0025a4ea52c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1a7bdec4dd6b4f7f79a706bce79e2b1581a7e1311931e7ffeeee64c63735e7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23dc94dac5393969d436eedfafcf8469fd4d78e0891ebfc9e40b296cc651a15c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad6286ead6a67e476bfd1221f69d66ee40677b4152f068c52944638490b61f12"
    sha256 cellar: :any_skip_relocation, sonoma:        "53d61b11fe2033343e44486d7c05a85df0dff80a371a2d9627ab0998dc1ddda9"
    sha256 cellar: :any_skip_relocation, ventura:       "7449c436e29015275032beb2b9060219f6ee92c770fadfa61ac8062581fad40f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "705cbe9ed0db0bb1dd46cf16d6de6839d4b5cff189be19c25d11af317534c1d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11958eb1267422db69aeb279e0a9741f7490582c0d14f7dd95eea7f6cc1e7d30"
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