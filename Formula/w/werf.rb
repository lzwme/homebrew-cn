class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.15.3.tar.gz"
  sha256 "2515119fce5d4c6f76729eee03a29582d8df7e1eb8d9be9f70b6ea60f2b4dd25"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52fd70bc0aaed42d7b39c1c9c9a550f7f5d272a047829445b51842f7e4d2e485"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d434642182cef77978afa5de24d6b1d6b300f067eea52b8d692f3153ceb81494"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee72c9c774408b29415ce9619ae4dc2d558b442508ca91104833b1f8fd0dff4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "688efc82633a8615b2a488ced8e30df96a7db6e536cbb50b826da22d9ced1a05"
    sha256 cellar: :any_skip_relocation, ventura:       "ae2200c0d06c4aab100cd92e90b29aa2467e5483142d38d9e6a678e535fe84df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6866e0262d18aade2da69244a85e9381cccf3ac4c1ab3245ab9a429a68f5ca58"
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