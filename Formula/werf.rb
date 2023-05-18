class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.233.tar.gz"
  sha256 "29616cc894bf83466fcfba18f68e499f080636a2fc0b66305f6ad0038ca053a1"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20d508bf3756edb05c6791261be104e5f7ed6f95de9e25fc5d9ea274b872de58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0397e070e6a741715131c15fb41e236bc33145a36a0efb70118b55d92be661cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e2a7da94fec680df0eac47fa209a2d7e11e49a203ca90bf938c5d03493fe37d"
    sha256 cellar: :any_skip_relocation, ventura:        "6186f0c5f1f331ba42444b16eefdf3029504146366861db853ddcdb1cb0df382"
    sha256 cellar: :any_skip_relocation, monterey:       "5bbd10d53664a42e39c70b2f7959ec59990f90c0d70f57080e197ed712c17fbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e28e557bbff734a6ffe10588795775a0d8f6642d5c8e16ad6705de7d79f2b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cadfaa1602a5718bb4f59de4d003466566f00185a93d79229bcc00dae36bb303"
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