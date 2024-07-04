class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.6.7.tar.gz"
  sha256 "9be9ac8ee0e951df82e448fda18026db16a4a075dc02a963cb6a677c4ae528ec"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48ebf7c346a8c519b44bdb27788346102679148bbb1ef22e68a9b62908c6545a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8987c2fc4696dd8440bd72666235feb4fcec16556e169d68d4b76db30da5f604"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "416ab69d85d26ba9e24e86f15f5be50eda45426f4291dd348d56005fa296c067"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb56f44b16e3b376493d364818a90c458eb82a5badf1f7852c52580758cda9c4"
    sha256 cellar: :any_skip_relocation, ventura:        "f3efbcf4e75e4ce1676806a505b8e54a015e4cf314c605ab24b3abce4b29362c"
    sha256 cellar: :any_skip_relocation, monterey:       "57f2526bc2d49c1de2d0c885d54907e652a2bfb23fb122ce981507e750ec1c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "422560d78bdd0a6c643c3193e6af3808e0fc91aa8776b982c68d7f3864325334"
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