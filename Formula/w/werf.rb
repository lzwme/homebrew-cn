class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.8.0.tar.gz"
  sha256 "b8151015ab32bab311dc9bba424d6d82cedef23b35b5d1cf96ad5ca8db3d9bc8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03ff805bf1c1937a9dfa3acd2bb9a8af468b3b6f0b9423c210137c1d36e18253"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50e4ede6d300c7a0a73d87d839191f5aa9fe5e7c5595112319021e138083abe7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42c6e64e5e7b175573503cf8d7144399a0ed99eb534fd579889c9905303bcc79"
    sha256 cellar: :any_skip_relocation, sonoma:         "16df27c668b2edfe74f868dbb70063dfce0cb88311c3441e8cc65fc4c1f84883"
    sha256 cellar: :any_skip_relocation, ventura:        "fadf6df5b23fa01aa23c39b71e71de9740d17a66a6116c44f2e218db992dcfb1"
    sha256 cellar: :any_skip_relocation, monterey:       "d2ec99438b9af4e94b06b4db816d7ea492b54e05dc6d0ef96013c4b7cbe5de42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "612101291e8b3f4e3b2c5bf259d3ab06ddbb900936f20dad6d91d47c31f381e1"
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