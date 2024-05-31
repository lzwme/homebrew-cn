class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.3.3.tar.gz"
  sha256 "e8005da77ae819d8b8fc13b9828af973b258fe9ed48e9d6b999bd31a2eed6757"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c052f368fbea3e59df288c42f910a22f835dac10e9123f5cbb9eb3c31344dae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f8e1f77897cccbc0b53bca9f0fd0823759bf67b902603c17b637f4eb949ce40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "931831c5b36ce8b85b239cf539f0336cc7a9e7116954faa387e05883f1160819"
    sha256 cellar: :any_skip_relocation, sonoma:         "2537dfed96e459cddda8faf11adb06b42a6129d9141752fb22c40f8bdbe14523"
    sha256 cellar: :any_skip_relocation, ventura:        "19b722711ac42ebfd0895994c78e581faa29f872a93184ab41877d3b95458ae8"
    sha256 cellar: :any_skip_relocation, monterey:       "74f8a928739f15dd23a220f264513860490af0740c242905824ad28fac13b86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d3dcc018c6248541812b76d7bf07e5e3bab08536cee617d0947548bb6264a23"
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