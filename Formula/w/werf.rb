class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.32.0.tar.gz"
  sha256 "9da5d5d672f875ca8b75558c04dcc0951df00f21ac4e3d1bc5d3e234c0f47a6e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef52d6ffc73828859f4b3deb72b901cdffac09e747d747b454b4a51e69c5083f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88f1ef2e0ea8521b4e09d2c4c57624d298ca94828a0d3ea84eb188c1449629fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "454015a15b8df3357ec7c1c4f519080c3a6a98739f38da2f02e3b4ae9ef2fbf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ae0d8b3f7ab8e72cdf678bfa13670b9a1eacc3c89de7b2655956860821cc9ed"
    sha256 cellar: :any_skip_relocation, ventura:       "ab3bb6e0ae68782d3b4bf394b6a3391257d0166d7bb37352aad5b305875ef742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9df479f69a3c9ff55264870174fd7b85acd8f2d036b9e3d5e4d84b1f9e87a1df"
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