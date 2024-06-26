class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.6.3.tar.gz"
  sha256 "bb6f65d9fc5efa4faec261a5b1813fcb3b371e20768775760113f4caa02ac87d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15367c1254f38c2c1fc196d445e6f9435ace12cf7eadfffd247cd30a48cfce4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8db62696d724b3fb1f8eafb281f2aa429e9e7a08d213331f9ed47fe4c0b31570"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a92cefc31e0e571b1c0f89bbb8266e4c5b758098bb0f3a06a204b7fa82dace81"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2a8ffd273f8aa73d3b1f4471b7ef832310d15c6cd31226e30459c7ee1441178"
    sha256 cellar: :any_skip_relocation, ventura:        "78c3446eba96f453b70fbe3df5c7ea7d061220af981265331320dbd5067ea713"
    sha256 cellar: :any_skip_relocation, monterey:       "791922b870dce72017dbfea2baa687b42dbe368175736bc680836c58a872b4fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce55ae5d2c712f67c71decdd7983e43f49b6ee25fa76a033c5d30ad00b5b743d"
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