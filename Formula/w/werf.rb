class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.30.1.tar.gz"
  sha256 "31ee154c67e2165a5338092f82cfbe14024bf5e55a8d50fd2d175858dbd3aaee"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d71650fb04b49d37763a0689111e35f76d2ad2d05f0d4e6802a1ff8f110afee6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "956645e0bc96d2a8e2c4091a0d71ad6a3a6bed2306b3b9f7d29503c894aa66a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "677b6aa2985e4984def92cb3b29b0d7a69fe0336c47655694a03f33d47692306"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cdcd5086beebee82a60dca6ff545fcc8d6c9ef6553b91fdd9d05bfbea26c3ab"
    sha256 cellar: :any_skip_relocation, ventura:       "3061c92486a41b9f88933c05e223e24418fa899d1ed5e5bccb6a904eeaa94029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d72e82dd899ea74018a9dc71ea188c83c0406a547be8b95cf87bc1bc882e773d"
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