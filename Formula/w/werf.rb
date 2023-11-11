class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.269.tar.gz"
  sha256 "c354a0bdfacca3d387b39750751ea6bbbb45650a80540cc9676e50337575a9b0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69c461780912a05025f3795ba6e81983ebb960a7118210af4cea90abab9efc2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ecbccbd79ba5f4718bd15c3de20563c4628fba97e818e8fbe783e94d8fac063"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2223f1854efad01a35be2039274f5fb2220ed6e19fedf2a4956f9b40e476da39"
    sha256 cellar: :any_skip_relocation, sonoma:         "cff4e2f7576f63f6bf446bd83108a7774ffd892887ec3f5e6a7b118506e64e1a"
    sha256 cellar: :any_skip_relocation, ventura:        "35e8ef3b2dbd66d48dd2bf2ee7b4941ec75f7989f26ce74b7343aebd54939198"
    sha256 cellar: :any_skip_relocation, monterey:       "ccc099941fd3a02b11f2c4417396125529477bc3088d583cf5cea1d2151ae776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1e74d359b4524d15f04624bbe087556af4448f67b3aeb183a6ef4d5c3fa923e"
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