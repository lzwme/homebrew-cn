class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv1.2.302.tar.gz"
  sha256 "c9f3ec67f7f6709c8ea5af0cc5f203fe502e8d93c224402466ac153aaabf9425"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbdc46e81d3eede804f9323b3d175abf35f5c06521e1c38c7b7877b6c5987c6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "716d2cdeed6d5328c26e6127a9b3cf55d101d53e8975ebcb03644b5afcc16490"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "598b8f4f87086d32a218b03640f039b166ccc111e88861c200775db297809f7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a992ac1e30667757d58b89c94153f23a0a06a7007ec844a8da8a75bd35d8d0f"
    sha256 cellar: :any_skip_relocation, ventura:        "e3273524aa214c29ef5988c33cbf1401b345d87a5294aaf60805c6a7a41a3e14"
    sha256 cellar: :any_skip_relocation, monterey:       "d0605afd1d18287e2d43423581d5d66159f6fdf3a88b1cac03d4f02e4ce67881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91c8f85bce86fc98b2416cce598b42bf6848c547483904b8bedb8cd78a732f7b"
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
        -X github.comwerfwerfpkgwerf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.comwerfwerfpkgwerf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:), "-tags", tags, ".cmdwerf"

    generate_completions_from_executable(bin"werf", "completion")
  end

  test do
    werf_config = testpath"werf.yaml"
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

    assert_equal output, shell_output("#{bin}werf config graph")

    assert_match version.to_s, shell_output("#{bin}werf version")
  end
end