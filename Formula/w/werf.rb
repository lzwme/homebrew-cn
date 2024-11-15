class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.13.0.tar.gz"
  sha256 "3e4bb31866b1aa76ca061254dbba852f92baa1acd281e46e76b81e33c04f2936"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21dce2cf19d9293c9569440719ea72b1a5648628a7cccb0b3d63902370c7cd2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c75a65059f07647931968fd96d87709ab3b6c8181e473bb98e23ba0492210ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4f2a5f9804d069512c111de175341c69b54c29be731cb2717b3b22997c1ca50"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c3f041e67b695b2bd3141234ce5961130e32d51584e116be7b2750e53ccb575"
    sha256 cellar: :any_skip_relocation, ventura:       "8756997f0eba533123b7f10d50af9733c7a364adfea1eba59148d4b21c8bdcad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcbebfc606c2e2e29c64ebbdad34cbc94a95a1844e8ce8f60b4dc5553e430cf5"
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