class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.6.4.tar.gz"
  sha256 "018490b4ffeebc226e50a8736b7d96ba5f5894db7edc32511da3e7e062fe2fcb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a49179fc30bfdbca4b15751dec79b85058ea8472ce443a59caa62a618c74d506"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b5cf191bcdcfd1a3ec42335286076d4045e1d1aad44e2315faee66ef7b07c36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e68e5b9e982d0f57639f6c7de17de53526cb439de6c2c9951c6322c1b2b09b51"
    sha256 cellar: :any_skip_relocation, sonoma:         "2fd45a21e123ef5fd3641f3e946e64f77a4e711b5470c6b8ee5c7f2f07263640"
    sha256 cellar: :any_skip_relocation, ventura:        "3367755bd9a4db6c24272dbdee98d4d5db53b8c4dea677ce9f4ac38d45b0aee5"
    sha256 cellar: :any_skip_relocation, monterey:       "c5ed64bf27b38bd5944569a1afdc090a3a78e9234a7727a73e5e636307bd5989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca7524cace80bd30db276e0276c477545faf8d6691072691654dc34a6fa9144e"
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