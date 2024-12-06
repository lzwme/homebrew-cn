class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.16.1.tar.gz"
  sha256 "7394dd28907567c3a0ded8eddad361be1da299d829079346da12d0b45b2a74ab"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63c52d7dd420ad7be29156712840c7c33b6553288901399146e367c345943bb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf218789cfe6d62afc5b3196885e485aaa02b39e16110f0da2f9685a8eea6603"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fb526f4b08f95505653cfdc357c2991fcbb5b6d17d4f8554aa26d137b1eebf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fb3f0e21e798858acf303e02767723a9e33b5e00a503025b59a0ae8562467e7"
    sha256 cellar: :any_skip_relocation, ventura:       "11c055c0f50c0ffc8e8349bd1bf693dc65f88f29eecdf32cfceb45b02bbd9511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d71e303b883ba28c6be0b9b30418e3a65aafeeac29c626ca99c5b62c3898550"
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