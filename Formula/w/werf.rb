class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.55.3.tar.gz"
  sha256 "3c874068722a579cfa649fd082e17ffc4b171585a7a10ae7d3bc64a9f6811fda"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cee1d8fd2df42a91f8f2aa42970275e7df80af9ed268997042f41ba9f22ad49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "710ca464164a1e911eae1c229e595ff6e391b9572a0889d890b30c8a67476d5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc83738168425d5662aa5fa9cfc4f6d3094a8b71db8e28a90b149618d8ae4c55"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a62e2addbd63c2517500250e162b38883e526ad63e09f1399ec0688c693d312"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f887ee8ce355293c72e541e54498989150cc38d44872eef32e021506e49b63b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21d738b4ead46c935961eb3acd010c414697c804b11f47b2b601024e4447ccb4"
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