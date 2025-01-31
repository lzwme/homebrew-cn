class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.23.1.tar.gz"
  sha256 "c9e6979a5072a1d75a34ea85a384894ba61f4751e71876ca5b66db92af7bb326"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a937463bff25a9530acc4b8557a9e5e962a46a64326141a2c66df3a9b64e907"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b847c5428cd3446029f469f84ab49fdb732bd4cc0eec9b703f185f460e469770"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cd0a293e6ecbdce26f783cf3b07fa6deffd5c8c8ef8261e49d011dbdeacd3ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ee38ebd08dafe6cf41b9a7f4e3c4b28a7a88423ccaba91b8b302a8a9133d745"
    sha256 cellar: :any_skip_relocation, ventura:       "18e249c87c6b91803c82111e6cce038883cb4919725abd2b319ead50359e5097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5192c4114cc51e9aa091518d0c884ba8655b56256331f0d4ce0018793523912b"
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