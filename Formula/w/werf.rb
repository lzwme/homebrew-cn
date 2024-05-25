class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.2.0.tar.gz"
  sha256 "d56410281292bf8565dd2d77831f6a18d15a69b3e48e57cfd5848db01fd2952a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c232115a9b93c2b78fd07e9063253a8c26a9545c3ad103a48a734d772f97f49a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7754a3fd4e3fb5e54e0e1b5b2045559293ef44dd548d20ec6b93f47b51712a0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ea51a9c1d4a0ab04588b210052cc88e77d88116c98a4754f3807d73edb2c49e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef2ac578d96f642ebce81e83815c956b787b2adf627cdc16c431aeac56cb04cf"
    sha256 cellar: :any_skip_relocation, ventura:        "96dffd72cfcbd02a3c2670a16abc4d9522efdad3dbad7fc7a8232e0348fd6cfd"
    sha256 cellar: :any_skip_relocation, monterey:       "1ad7cb21d3875402e8205bf37f4b434d7c16ac2586172dd61abd82b1a57e9157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d0ccce0894d31833e0b8f106a6e96ca3c05aa39af9cec31ab3f55a9c04badd0"
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