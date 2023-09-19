class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.255.tar.gz"
  sha256 "163c771e67cffb83b2a44aaf12db8f25ad37add6ed4141e5a8d26b26b634f789"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b57125020a129455fa60a55886047c2c1ac5efc0c706d426042b91bd6c201744"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "879b1e90bc9acb3b53ec7f98c4f78188c7374ed39c98951c2cba6675738ed586"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b5852d2cb280d9187268fb233ecdbe38a56163a03329c313a38274c13a104fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96e36f5dcb34c6af6bf6772d60e84ebb8d41d88c4b3fed3ea310413eff109d6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1507218d55cf0398500a70af7e48eec4bb6369e7cd0fc5785babb86dda0418c0"
    sha256 cellar: :any_skip_relocation, ventura:        "425e2136227a08506546ec6bfac4befa530a00d300bc855c767812dd5ce9be05"
    sha256 cellar: :any_skip_relocation, monterey:       "9852f996b09144ebccfaaecbfbf3b34675fb8aca9fc3a171ca2000b0c27b72dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b99226179e135a3efbd731deba4a80ce0aa381ac97317ce62104116ff6ac230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9f26837eb46de84565d2e1a9cebebf284340939921419e79d9b215071f3f3d2"
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