class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.238.tar.gz"
  sha256 "dd7996b353b4f820bd4ec2ccbc607337ae4c36974720f9e5407bd2c8cb6f7013"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb8f8882843280dadaf31d93d522e8d31f33c916d599a35872a18055092ffcdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1a954d66299fff0abef7dd604efa5b103297bc6f7f7bcc542cd32c0e96fdeb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70a947154be40ba7a1e7da1ddfa941335eb0ad4e6e65e5d80c7e14e638b00932"
    sha256 cellar: :any_skip_relocation, ventura:        "d657cc0c4b05079e916d1d70c5d9873aa381e046edf23cfc06bdc2fe289e9132"
    sha256 cellar: :any_skip_relocation, monterey:       "c8ae28ef073f124162ce60ba91ec6d5d6958c5895efddbb7573143c1162bb3d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d802a78c167a8b74b277971633e4aa54318c01edb89be640b5b4dea11bf1dacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "431e06cf1fd92e20bae5f152a9bbcd465f8a9cf1b3d9426fd65948055a3d3fe8"
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