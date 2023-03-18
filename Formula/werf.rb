class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.213.tar.gz"
  sha256 "47981fee0a06ed57210552440e5b77cb7499189e42de9af5f55a237e9a8d2591"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f46404e89b298dc9765bbdb3cd46be56736333a5f0ced4053b88a710f76fbba8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28b7c4f1907a8f057eac867f1baba623d25c4f2dc6d9bc03984c9e5810883a2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bdc6c564ebb3ee704a8319c390874d1e37ffc1c3e10700c81fa9d34abddedfe"
    sha256 cellar: :any_skip_relocation, ventura:        "ec619933eb73629c1eb61137c84918c3043e6c67da600ecfccbb52a544f6af42"
    sha256 cellar: :any_skip_relocation, monterey:       "fdd1e746a9896cd4fedf56bfd9cb5906fa20a6eaf21e97bf6e1c666a5f06fa31"
    sha256 cellar: :any_skip_relocation, big_sur:        "639c9c6cea765001b45b57f4f3b28bbe3be864ae44c489c1ab06a557e6292058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6b11ac61b819ee312dd47d3175ad30179faa82b4f49f13b131c64b39eeced96"
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