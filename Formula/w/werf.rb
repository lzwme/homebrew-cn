class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.14.0.tar.gz"
  sha256 "09694d670c30555117963c44bfa536fd37cba635e541cb523bbb9874ee833bc9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9498842fd4d0c74fd5381a4d382aadab37296bc8a00eecd3396355189ea2d664"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13064adf661dd513a405c0f653e0377bebf9343851f8f95ef4a01120fdd5b7bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63e0a04f45dfb60691babd42caeb45ea65d8351a4588bd3f377d2412f60da342"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c4d08127f61fcc8833d584e02ea3884ed0dc11d1fa91cfdf1ce0b4a1b743fa3"
    sha256 cellar: :any_skip_relocation, ventura:       "831e56a94fa114ee7ecd04e51b6da63ed8e44670702f0d0785602bdcdb125ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39617034abfb120e462a852315a229254131e1acd2d0c5e728796d5f3641bdab"
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