class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv1.2.288.tar.gz"
  sha256 "40706862141813bad371ed9a0a27d8e521710345a9328da010dbfbcfa128e921"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e134da2902f6c6383cfd44bc097e7fe8c587060535424799fb45e6c4d081d71f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "537667c1003a93b2fe1c993098508e776c5d9f7a59c972c54b5fd4d8a4e622be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5db20192207c1faccae284762cdf1efc85014d97e6d03317e848803cefc45b0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4f5797193e675145a890324c2bd2738f2b2dd48ef45f1b5098578326a5cc831"
    sha256 cellar: :any_skip_relocation, ventura:        "56b45a6e613a321445fbba1aa4d81ca33db48e70934accfb7f68739df0addd17"
    sha256 cellar: :any_skip_relocation, monterey:       "7afd0bb9d73b4417ee954452c2de167cf4da6eccbd647f0e3a7708c4f0d485ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d9e4d4b1026d56b250fd3b4b6f4fb7521d1658b75c823841db3958b33eb7e77"
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