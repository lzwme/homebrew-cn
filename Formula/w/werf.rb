class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.261.tar.gz"
  sha256 "16d5ed0b0ed80bdfd709d179f3915f1cd2116cc5c3b700039603593a17ecab14"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "196f86d3569faf2707ccaa87c9c01c1e59359de642ac802bb51f4eff19b51424"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6beeda43465704b320908c7df3d617fc50a2eb923cce90428095fe5ddddc6974"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91ebfdc6a88500f02778756d2459d8be44ef3ec6d183caedc4f1dcefd9a225aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "05762c17f3f9eeb57644ef02a12f45bfb87bc49b25c0088086ccfe857db74c13"
    sha256 cellar: :any_skip_relocation, ventura:        "8c2e4e5c909a88befb0017a085dca4200320f34f1e05a9433afd85427b8bff97"
    sha256 cellar: :any_skip_relocation, monterey:       "5020bae9593fdd17a1240357daf4092adce0404df44be501646d44685dfab481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a799db5e00c62891be705dd6bdff662df849870adc22d3bc427777c091ac270c"
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