class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.10.5.tar.gz"
  sha256 "871e7a42b5f5457b8a897178288e2d7a323ae78adee9f2015184238a32e88243"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cb1b852ab4e4b9b09dd2510c656df6ffca99d0032a2c4b6a072418b601d66d2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22186a8f55a096f7391bfaab323410246745a37399bdaf11fae66be02aa6cc66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6806dc03ed9ee8066423fd04f583993594dd83eb057415f49d6fc5a3022c43d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec308dbf6ebc05ba3c1e6a6a4fc46c0e739f40e78f4ee29be7e783af53fb3cd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1212e7388812c328a470ee78d8d2b3815fd22c8a4385acf713d6f544c438a503"
    sha256 cellar: :any_skip_relocation, ventura:        "4f33b5a053f5ddd38fb11041b2ae2e6fbf63923070e7e3379dc5bea3d1a756f2"
    sha256 cellar: :any_skip_relocation, monterey:       "eeb4a5a882d1605a2a15ea3b23e2ccbef7e7ecd0c6ec2f3202a22a56c35162b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf20e166a1bddcf548a94fac3cdb5a5b8c2a05524a19eea53551a2e81d98283d"
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