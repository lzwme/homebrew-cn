class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv1.2.305.tar.gz"
  sha256 "f9890c536a4cbc0097da10a076e5170327bac4f32f8ef33b86f5ae7fd5cd01b3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db1c57fbb811d86f9dc34b986873f1fd9ec3b05d56cde5753a679a40a2e13350"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0641643114cd21a532c6743fa1096c752099e854b32007c92e0080c91b3e1e4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06529fb0d20d1456f0635d82b3a980ac58aaec601b05deace66ac37e6af04f3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "94ce3710e8125a9d40b05940bd265156dc0239c545949fcd7e54643f1a9a336c"
    sha256 cellar: :any_skip_relocation, ventura:        "fb1f2eb7fae0b2c0a2bb0d0836bf9321eb3066fced787e6dbf7e5401cb9df59b"
    sha256 cellar: :any_skip_relocation, monterey:       "888400c6588f74d0908ccdcd24541a729849a27d8ddce4b7fe5a528a4904810b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "308e554a5c5ca133a0b3ab9d31390b8f30291796482d582cd71be7dc96979f07"
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