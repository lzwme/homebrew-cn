class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv1.2.275.tar.gz"
  sha256 "f62555751ec02427a0952c8eddcf20e10007ff18f547d7ee8ac3629c9fc903ca"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d301f989c6a64ba11b01c6455c2ef43bbe6a8e74c0e8563ba970f1b885286a19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dff0ffe16f618bec8005da4b49e43b7d68b23232c7a4423cac4b0004192e4081"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "302234be26837e5411ab84f7c8dcd2b376f477740f89ae267f5bca20ea18c30d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac7e2f1e9fae288bc6f192c0530349cc4e0af0d43833dfb9108c5cef261a714b"
    sha256 cellar: :any_skip_relocation, ventura:        "fd8156a09cf31fe1736a6c54d4f647ef16980fe0fce675dd51ef4d6a02e35db3"
    sha256 cellar: :any_skip_relocation, monterey:       "6dc04b65b1fda2c2ad4c374b0016dceaaf6cb17830e18b3511b9eebda4a67b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48ef2bce9b6c8c8f9870e40bab90c5c360128ace15a6ce7d3b3cf60e5b198af8"
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

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, ".cmdwerf"

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