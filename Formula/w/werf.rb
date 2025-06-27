class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.39.0.tar.gz"
  sha256 "fcb2d6a3351d91f0cf945e16729bd98f9117ba27cfb36e63cf8d5857f1265324"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94e0ed35613647ea73a8fb757018a4ab8688c57fdb01d67c81fe5fba69be1eb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b893178f316e31c8f40946df789c4facc9eeb7a1523c6b26195caf878ef022d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a592ab2b9f1f6adbed8bd0282ff736af247d1bd39e28b296748ee361d8d852da"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ef0bdc1a6f4b6b83a79533e680d4ebf18fce9cd92f96e53e0e2a8d5924026c2"
    sha256 cellar: :any_skip_relocation, ventura:       "727301a310da4fdc87b8491188f55127e6a62c690ad102118d48fbe01479ea22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71b05e5a9fd2fcb7a83d89a49db4656ecb27f23ebc72a127b1269094fafc05c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e718f25c8d605b0d07e37242c223c004aae67dc617ef7fcc8e4dad8ec32f196b"
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