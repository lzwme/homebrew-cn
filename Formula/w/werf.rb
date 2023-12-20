class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv1.2.272.tar.gz"
  sha256 "23adfd0e2509586d2fd3849616ec8c404181063c77b979468e8fd4e12261eab3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67e37ff44c1045312e9296feba94bf992a12ac9fb68c6451766da0dc27a92d99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4afd9c586dad8f3421143314f356f0eecbdf6aa255fa4fe5d837fb518fdfc64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c06d76f23d1954de3b8d9a6bfcd496adc8e41e36f6b79404e9afadf67b01059"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7f5a0f6851f929c6781752be44438ef5a2727f147ed3474e37149367effc3d3"
    sha256 cellar: :any_skip_relocation, ventura:        "8beb510ed634239f8ea72cb71562c42322290fa8c0e6c482e22d83c36cabe3eb"
    sha256 cellar: :any_skip_relocation, monterey:       "dc2d4cfac7a67354e783dc63e40b78e4a93496b5fcf83fb08a3932a0d95fa01e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a21f04c2d1f026e5d5d83ac6e7045ff002f4976efee804acf1ce576daa8e1e6a"
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