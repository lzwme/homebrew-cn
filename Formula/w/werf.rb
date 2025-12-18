class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.56.2.tar.gz"
  sha256 "40af139c53755876367508ba4ebe8376c6d85dee59784554496944dc60ae45c8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a304f8e9c4673af83e2a5fce9ca74091590e87c1baad22c9bfd60a43e77769c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2ee4312f865b5b995d9429128682b453062cd12467de3f89cb8c70cf843dfc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e9c90ea485399eeabf1bcfc2bed016c7896600e74c6083ef689b535a2113a01"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0bec8342452e9077154dc052d413089c0e7c8fe972f8b7bc697d3727aabb879"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7b9af0874250c34283a60c2bec67c3866d98fd5e34868cd51e73a9703ab078c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41ecd4526ccece88ce54e014ce68d5ac0d9ca561ed3f86da0338079931c4d796"
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