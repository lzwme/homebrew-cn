class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.23.0.tar.gz"
  sha256 "3652f70f23f10a406a4cca4335c2aa2e0c0ca4d7d6af5218a0b57c96bc81b02c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4e003011955b2ddcdb1211f333f667867fe26b0591c04f79a8e6577c970b76f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "526f806ca382ef2e649866333b565b8389367d2e20e7dd4a74e73870fcf1c7b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cd7c4683418e4f37a618a00ad7bf162cc71e3068b1520738d32ba22bd3a7f86"
    sha256 cellar: :any_skip_relocation, sonoma:        "d51c95bc9c754cf40240a9bbbb698ce5039ca059a049b13b080ed56f0ba1bc3a"
    sha256 cellar: :any_skip_relocation, ventura:       "802f683a5509e9d551c0f9d966c336b02046b5194795780d6a3b916b22096b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56a26ae5bf4e1534f9628295db12e865dcb5bfb62525f42d39db6b836cbe014f"
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