class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.265.tar.gz"
  sha256 "f7263547fb6db8d7bf9d6466e9f8c73a9c8e4c4da63b98f57dbc3f0a65639e43"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39db96d6a6206a51683a9d827348d5e6ef806fb1b4c4d38c427d25c2496c1434"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95ea259947e2c39691790150b5468b0691d11ed9f726b9abade800e1d5327933"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91384e65fe2a29614154f4bfe50998db6513f4d301956a3028023fc06ddb6cb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd603dad7f9c22459b5df0a78f1566f740f4afe7e2b14034f96267328529dc25"
    sha256 cellar: :any_skip_relocation, ventura:        "06c383dab56d5ab03d676f6aa455bc84962c2f8f0fcfc58956ef87ca093ff2f7"
    sha256 cellar: :any_skip_relocation, monterey:       "2692e4df65a9ba2f854b114438d1461b6e0524c4b8264ac0e0bf98d27931e5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b673f258e76fd53a8753ebb852365fb1b8f4579ac38766e7560c3be2cb69f1a"
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