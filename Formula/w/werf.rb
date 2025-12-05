class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.55.4.tar.gz"
  sha256 "72c5c23f52f09c608a36febe71252a3658b92cf00c80e71cbfe19a572d3e52d4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c368a40e9c71a33231b434d695f89baacde38e0eff7ba2f09367307c1d644c20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aae87475585ed1d8355e8315739dab011ddaffedf56575c8f3ac24606569b3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b99af5aaa12088f50e42cb6418057624a827a7d6a95327bc8c1221e2e774927"
    sha256 cellar: :any_skip_relocation, sonoma:        "42b8f3424f58ca460eb0d7670853d1e1734831fc5058692c425e2478a45f3b4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84bc00dbaea567806a98b3bfa3254826841ac9590d01b8147657627a802294ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fecca33b932ffe8f23099aa95a4b3beb2740d91fa3aafc9bb64da23cf717cdc"
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