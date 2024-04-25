class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.0.2.tar.gz"
  sha256 "61b42aeeb4dd814f34f99b839421b762bc1618beea13200e2fd676480e930650"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cba37421476333eea19682c32315db1500a4c16cecf5f64584582009797298fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e7ac762ef8a742ee21f3f09dcb432b7f4cf809f842625acd524a934e8f16560"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76be1a2ce116f09bf878a931cc070e20d2c55280d590532759d1b36ebe938f0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "94198667104c26a74f455aa8263acb863a04aaf4a695e329aaa4c99148146f98"
    sha256 cellar: :any_skip_relocation, ventura:        "f74cc6f1831799df5a53b6ebbe03fa5de43adda4ae3923e6cda7b791c58901d6"
    sha256 cellar: :any_skip_relocation, monterey:       "2d4cf18140d6504f740d9b428d5ab370eabb2a9beed892b34a4f86397a3cd3fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fa38d2dbb8d56e8977e55f6880dd0d6987c3299c32ebb766a2d1ba846148e49"
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