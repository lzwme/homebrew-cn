class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.16.3.tar.gz"
  sha256 "a1ebf868467bc51a57a245e827a0f5121245af1a835ac0373589803e2061edc7"
  license "Apache-2.0"
  head "https:github.comwerfwerf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "929d2cf73394292bae2361bff6de5fe9f9444b79878eec005704150f9de3cde3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cff26fe611f49c306e35e46888b6e0ef15e56c02287d1e9f0ca1e66442dc3ddf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cf40335335bc06475757be14d89568ebe1eb6f20c68c689865ea8af7ec941f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbdf21190923c7b6576e40a90d38163b485c6fa3a6d5ebc4b35d9cb2bc96e4f2"
    sha256 cellar: :any_skip_relocation, ventura:       "0d2a3ef510bf144d3d3a6b315a617a7151ddd9563b51b1027f74c927ac7ca62c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5db4ce69d5857b630b9d1393fd36b13cfe905e9a9c1e84282d580730b4cf7a46"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.comwerfwerfv2pkgwerf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.comwerfwerfv2pkgwerf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:), "-tags", tags, ".cmdwerf"

    generate_completions_from_executable(bin"werf", "completion")
  end

  test do
    werf_config = testpath"werf.yaml"
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
      - image: vote
      - image: result
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}werf config graph")

    assert_match version.to_s, shell_output("#{bin}werf version")
  end
end