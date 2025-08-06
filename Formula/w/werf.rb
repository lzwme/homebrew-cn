class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.43.1.tar.gz"
  sha256 "2870d4f8f44ea8fae8c2a423e2e7a5a6fc4fc800253ba5f6bb19c19c815fcad3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4be38bc8076d8787793ded9c2e34f6c5296eef6edee3efd574709bd129713f55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd29dbfe7180d57f420a471d1d2ee5bbb367d64fc55665f6383cec59add8948c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a684ba3900f3f5ddc9e4075318a632e7e91c7ebd72651f93421d439f0587a551"
    sha256 cellar: :any_skip_relocation, sonoma:        "6351a20bfbc0932a2a20cff71f56a7bd4364bd54fd917a4ca5b1049b6f0c1c27"
    sha256 cellar: :any_skip_relocation, ventura:       "3eafdf621b2e6e2f26edef8c0b63ad7a3788ce5b287e2fa7e1d66fbfe67edfc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "904eded6e8e2ca737e8c9b40d92c740884a41839a74452ac914b2343ab040f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bb4176afae98ca6f506d1a9b22b796944051239fc439568f835f4e6ba9b6cbc"
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