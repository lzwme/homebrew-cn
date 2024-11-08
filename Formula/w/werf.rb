class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.12.0.tar.gz"
  sha256 "1ae60cba604c5d83a642fc8b7220608f77fae352df2b6261faee9f98d4fd8ab5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb214befd6a14c507ba847f5cf0e54ef02e876d62ff2f3562e10f37153565698"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68b0abb0f675744d1624dcfdbe76bd607053bcb1f7416b025c3d6dcc285e82e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0244e264f7f243dd02f37a74a7b6d98f14956f6ea845d7476f87aa4349ee6970"
    sha256 cellar: :any_skip_relocation, sonoma:        "16cb9cf0c33870d16af2b65e3094f198e1807a50eab14c395ee1df7ced1baa5b"
    sha256 cellar: :any_skip_relocation, ventura:       "9bc631906df875faeb137afff5aa8bceb85bb8f327acbcfd1d85bec5593a4afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2819faf33e8c1413834230ba12c311ec47403bf74dda4fb5aed788c02ba4999e"
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