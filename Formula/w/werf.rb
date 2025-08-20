class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.45.1.tar.gz"
  sha256 "f44e1ea1c7a2353a567c32bb8bae31f8d9b7f10ee85bb8bc6bf4d25c387b36b0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e429edccc13c020fc387b5e5a192379bdf2268b9c1846d56b703d5eba664bfc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c31f49845fd65362b383fb7b3e228ef0dc0236f1ae667908e48b30eda305b65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c2b6e40d86e348bd3efa54028d63eed2aefdbc9ee827da09dea199b18732e2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e28474f39d99e82b05f442f743f0b6a9c3646b447eed87c612e0135c422bfc6d"
    sha256 cellar: :any_skip_relocation, ventura:       "09bb8e962f3793150e36e275b5cb976f502797532e0b63ea772d77ea5d7f74b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e707c4bd1aae9950c1dce9c865796684877ad61083463fc6b8a5b64d6a1fd204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73fa475ef1fe756aa6d0ff9490184bedd3d5b897f2213400abd86ded7726abef"
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