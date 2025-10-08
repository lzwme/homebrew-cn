class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.47.9.tar.gz"
  sha256 "76897538b3cf8a68c0a7c6db47c16fc8bef3481d7b9f5d6913e31503a2c888b4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bb3644019f51a0ac8ec5cca1e8892456b1b6d8e29194ed0c9e8aefb4bc92865"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "004818e46367d0fae49c5f27e62a7b0cd98f73591c7a3f8905fe31e270107c74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "100a12d1d594970bb906ac67c0166d554204390bf815c7b5ac1ebf7f683e80cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cd81316af85a88f0ced951ab27befebbf1da5785ded8a4166c95c420c022858"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62df843a4ab8e17f4208818cea58964ccaddc735ab111df5d0f5c815d510273d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4c49ad59985a3ace86299acf949199c379a0faed023ffb0fe448813372c373f"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/v2/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ]
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~YAML
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
    YAML

    output = <<~YAML
      - image: result
      - image: vote
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output,
                 shell_output("#{bin}/werf config graph").lines.sort.join

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end