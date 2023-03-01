class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.204.tar.gz"
  sha256 "f0c8b9d674b7cef57f098a976075cb2b6f47eebef8e0d494015221f72fbf7078"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2aeec46e6ba0c6f3aebb2814d8f01ae434f21f022fce5fd0de5682dc23d13da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75d3c06c92ef6ebc211e5c25728f68e46874ee4c472b69637cd7ce072635f5e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1766ea38b78ff1f824ccd004c59c1ca0bd0b3a1182591fca6df19967cb288467"
    sha256 cellar: :any_skip_relocation, ventura:        "4bdcb35884a7db773991468c6c0ab0c5cf828b8b8ae04a37b38146195db63722"
    sha256 cellar: :any_skip_relocation, monterey:       "72db8ab32fb2fa2d18ae254dc2c75389488437fac2403884360138fc6ec90c19"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6a79dc3914d06ec158dd723f5db06f21cf1e825620e64578ea37ee4e711a1f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b1ac43e680e7ac3612be376fd4fa8c409cb1a8be9d7588026abf6a8d4d2d9c1"
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