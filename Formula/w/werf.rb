class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.7.0.tar.gz"
  sha256 "305a56322cfe4761e0b5cc056f689e00518e8f68448040e24b8a6799dd1906f6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "faa64a642dc09325b320b39946c865d7c4a656be6562aa50fcf4da622a81fc30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2092d1660f396964131d35d919b2112e798d908ca8a345ad1383d7f49076a91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ba7082ad3bc3aef5d10bae43ff6ac058521019bf2e048a76215481255d7298b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d160daa99b3c7f22e8d989740d7424a3eef2a60b258cf641a0c945fa32b51ef1"
    sha256 cellar: :any_skip_relocation, ventura:        "df7c8d54cf9b778ca08811f7a9c045c5e19ee307e8ce05983f29feafd3dfabab"
    sha256 cellar: :any_skip_relocation, monterey:       "d4993af305e093ccefad17d0f5101fa841078c3ef5afa65c3c5fbe24a147292a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f94d7e1f3be06e053bb06b8107b4ab26f48d404876ca36fcc0a0e19b20964fd"
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