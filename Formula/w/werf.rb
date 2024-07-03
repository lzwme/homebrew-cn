class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.6.6.tar.gz"
  sha256 "fc6297c78c8d3e4bfdfdce890052111fafdd651e34e3562b69eb15aeddeccc4d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15f092100a1f7380d20187e2ab98dd999e6aa24238409950493e2446df9d6fd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98bf44a01709159bee428463579c43aa2ecbc69be69d819745ccc5b98159238a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7b1d5f43a83c54c16d30daa03c4e892c84164791dfc261d2cc7ab5154defd18"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c40dc56b7a2885baf493071513ee88a8d7aa473e68e220291eb5d1a7b7344ee"
    sha256 cellar: :any_skip_relocation, ventura:        "6b7d87d7a3b04dc227dc0a7c3853bf3f620f1baf1aef76e8bcff85ecf3545f47"
    sha256 cellar: :any_skip_relocation, monterey:       "ba1627ebd8e6eef07c4709f734a37b7493254efd7ce28d8130577c9c847b67d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbed770c8b8d79e309812666c5a04dfec6af23257f08d3d728e59cde763d4f51"
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