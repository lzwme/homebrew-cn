class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.55.0.tar.gz"
  sha256 "6dacf98bbb0eb0de409d0feeec5d7c7888856ecf7bf1faf604610d23d98c0c1e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3d17df722844ecdc1c1693246ee3b742240f1b42d18c6f2062b4632511382d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07dfac93e1ae67a981763335c395005235acb9feb46f6925e2ae601a92c48753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0307f1ecc642612d86487bada1c65679088a449d4c80aeaa01b1a329b2968643"
    sha256 cellar: :any_skip_relocation, sonoma:        "7233b742986cd98535e994f005e96b2da3b03215ed41ed56d9511e50a93731ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75409c093b4fe19210ef99f7797532e36812cac2e706af33905aa0504ceeff23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecea051facfe5ee4ca096cc3ef555566e2d79def273a98fcfad948c404f83732"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

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