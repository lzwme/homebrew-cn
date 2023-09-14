class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.254.tar.gz"
  sha256 "89c700c43e662fa5d4a7d2d58959ae700c4922ad037c2188578c2219780a4f6d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "351b6fed6610364840ee0b15997ee2052fdb96af398e4deb3a0ca6e1e2287958"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c4ce0720b885fd291c005dce2771ea098719765f8136cc8b6cf1e5b1f7ce68d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b305d5e4b13c6ac413751c0865e2e8c56b2d01202a14da2d6dbe5d407b683df4"
    sha256 cellar: :any_skip_relocation, ventura:        "d5d3d0ca0e6498157471e3d0ce9a7e01af1d950a0fc6ff5ea72e25eac92c6bbd"
    sha256 cellar: :any_skip_relocation, monterey:       "eec9e971e31c890c84d20241160906a0357521da00ee1ee909da24b28107d9e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ab81db8d70cfbcb110b9419dfbf1cf726eaf2b36d6c94677696f69fb2dd04e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfebeeaa0965c14c27c0be292e9593331d25ea56253369acaa7704f971fe9220"
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