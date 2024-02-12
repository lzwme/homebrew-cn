class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv1.2.289.tar.gz"
  sha256 "617b4b48422de56b72b0ca24a8f776dd6f1751286d0501a4306a76a20e9d523e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f920081991ab229ead6330ada26c2b0fc834cdedf408e039cd988273a93069e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5df3bfb103b4a699c7ba331c6f997859b4f64e1e2556c25c5440121b6521b0d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb6d8a1c457e17fc2f213e39928ae83e83b003f3e52ed07147cc8a38b1716bbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "51f40febc9e064b4aa603ae626be7074636907f344dc6b0f84482af63b93896c"
    sha256 cellar: :any_skip_relocation, ventura:        "3769837c5dd15057e8e9829ed4e0546027dd9f1d0580c7679f4d03a7ec2e1029"
    sha256 cellar: :any_skip_relocation, monterey:       "d9968cc5a62fced8ca367c991aeff83d216222ed98a687905d94a60b4417f3b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ad85210fccb7339c6cf67736556464fe76459561ab59ecf6550c3043c29effb"
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