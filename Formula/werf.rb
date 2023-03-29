class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.218.tar.gz"
  sha256 "1e53be101d019667bf862f84561cad478bb40273db2ebef8c5f5a76205d5f32b"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abf64c295256aa631d63317eb695f28337f785a2dfde2779dc16ade0f99296df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d39deba1e06646f936deae3c8a9bd2b27fa255d862f8fe070781727e4553b3cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6552d82158ca49f4f846da18383011484d7ae978d1df92ab44180294a24ce767"
    sha256 cellar: :any_skip_relocation, ventura:        "2931a2e64da63bfe2da3bd1ec57e2e1cdf189d38b2b78d9010f5d4068fb69ea2"
    sha256 cellar: :any_skip_relocation, monterey:       "20b5e38fb01d219b2dc9e9eaf27096c9181106511e1a6b8f9ebd043e130d6ba1"
    sha256 cellar: :any_skip_relocation, big_sur:        "796768df716b66f1bc7463ea749ad2c49010841ef648f5fb0fc940c1301e1aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "034178d9360ad3f19064a8df47c498f2a223a2c81a38312a2d269a35701fa91d"
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