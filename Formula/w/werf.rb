class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.48.2.tar.gz"
  sha256 "5955b5615a29c7f1f5287dfde4aa879b80e7820ca46b229884e077330432e4f8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f295069478417bb74be20dc243a68e4663041b8d6bb2fcef31650c05bf319f6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad327db6b37ee679d41720311c37e992a080a50bf4e9918c69a6640b1bab428c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d52ad7c548a08bbbd319fedd75724cf4787e35cb0918cce8e7812e338dc27c14"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae633e1491b499a38e21f68b4d6ba5cdd7a0dc1d91ac6481baea1fb301c571bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a0ce5b65a55db2223d3a6c1add41eae01add7695a5792276a324a17cb1c7302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b7dc9fe38c6070e34dabc1b45e144fc9853e225dce265c9cf5349e50d14dda6"
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