class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.259.tar.gz"
  sha256 "2a8ad19f762af1be7140d4ceae4dc8ff634a9c5802453a20c4713837640bfe4a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7fd0f72b33ee5ed8386b1cbe56ab5fa73f111c1d22850a8f3cf9c6a9b43e64a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e52d29613f9fa223d7d86ad6b102de2dcf253958899e7665b17d5f6e096b708f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66e3de5decbe59a3f477ded00626a183cb938613d95b1e3505c665bb3fc78b33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f751bce8e9d0eee5a00e8ee32967f114274aa49e47b5626a7ac6bf87573f7772"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c3a36d9176b1fa771d23afe8e61fbfb706fa6a8634746c119b8d5ed860f75b5"
    sha256 cellar: :any_skip_relocation, ventura:        "3edd3fd5ac633f6727cf91ec8a88e99cb58c0bc8c7cfa31d130c6c0f86db5231"
    sha256 cellar: :any_skip_relocation, monterey:       "2c921f76e7f426b85192f39a92fba096c23d0846634000f8ab21a1d793c3b1dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "480c19c610842e860c2b5b35b6b46f9b9ffe5537aae47b8f5bc684788f831b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3792ae32ae971c314fac9930e39113a1daa3a65541488ecb8325bf2e7eb1e982"
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