class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.38.1.tar.gz"
  sha256 "bb680080e5da572d8e05b54bedb356531ca35d69a26174a5255c2ce28d6390c1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84e36233ffe2cd0ae9bc54a89558ad9048908bcadefad7de68f34cf9ebc3be7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77990fe756c6fdcdd5a52f72f36c77781586a7b722223448afedb6735aa995d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e82fff34cf9e1d1b8f8a1198f5705bbd7806e4cf14a687e68bac207d0e213759"
    sha256 cellar: :any_skip_relocation, sonoma:        "476ab3d7c7f9bc795042aa7894e7bbd0cc2ce7c258b02acfe1d33546360982bc"
    sha256 cellar: :any_skip_relocation, ventura:       "89aa2ca61439919b018cf2249318cefc8f4edafcdcdbe0009e1282d2099b425b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d14224389f7c9a94541d18e0edb7799f2067b3c6f9334ed7e95882467876a100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a06d8e3f33ac47356b8ab02f9f2b7a312401693133d9549d2b81e89502395ef5"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
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