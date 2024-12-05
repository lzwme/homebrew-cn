class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.16.0.tar.gz"
  sha256 "e4a34858582e8372c2500f1325e8ad397a578b6f2f71f0d396591344246e8691"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4b74acf17b8c8992d9a912a22217e96294bcc63ef99aa895cea45a3fc1eb73e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f280c3b6ed2cebc68191bddf3547635b1c9865fe85db2ee51c2b60b369d33198"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cfaf694c2ee1050ccd84c197162ba68baca4a467e5e606e32462a514fc2d8e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "942f71cdb39bf0f74d4f683c04e412f38271bd7dfe1328aea7dbc9a58c9441d7"
    sha256 cellar: :any_skip_relocation, ventura:       "f02a49a96acb5eaeecbfc1ef4e564078c5307286a95df662293671ef450edcdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e625411f8614e09d96bf5182f46397fd52b4ae2d649b6cc3d62b3bdc328bbb5"
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