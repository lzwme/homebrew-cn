class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.10.6.tar.gz"
  sha256 "7080f574c8e795a48af77a37251e3d814a353819939441b2fcaf481972caadf5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1da10c07154035b5a95dff2b4cda1ac83a518cefa54ff60cd0a3597585fa455b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7674fd3f2b8b70626c5057457e40329a251bfeb2e940aa637db28d558d1e1c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abe9b9d9044331d6c83ffb309711c165ce109cf8cff1b5466fbb729ca4236f5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a7c4f1e39946195bf4241f674df18fbd5c2322285be5be28880611625113489"
    sha256 cellar: :any_skip_relocation, ventura:       "c943181921fa4e570b2f217bb7c8afd4f5fc7e30c0e12224598b753a81ce9a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7c8f4f4804847b23d568486312e2b8e8db286077935743d98cc629c07066735"
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