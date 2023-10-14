class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.264.tar.gz"
  sha256 "4b537377cddc4fac166edff20326812578fd487d341490da0413ccd646118a99"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6de6a6c902e5afa211a8b5bad0f87518e4cd6dbbb9ee12e7a06ab25bf2bbfa62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c7d910f301d0eee3798ccba73bce4cc6f43d2f38ee2f73b8bd85f62d538e713"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0939dd4e415fb05b131bc44126fe8d4a12441910eef2e932737fd999a486ea25"
    sha256 cellar: :any_skip_relocation, sonoma:         "473c81f16ea9d209d478ee15c98c3cc287c118f7e9ff1a8d35c7a264ea2abf9e"
    sha256 cellar: :any_skip_relocation, ventura:        "02ad591a84671e8c57c983e11d63735a1a6accce6a7e987950396e2bcc521efc"
    sha256 cellar: :any_skip_relocation, monterey:       "f28b57856cfaccee7661179258788a901a6a663d2f865b4911980d763b0d5345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe8cf395a8b905419b177a76c9971b9d9e83e1deb1d0ffcaff418583dd08dedd"
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
        -X github.com/werf/werf/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
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

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end